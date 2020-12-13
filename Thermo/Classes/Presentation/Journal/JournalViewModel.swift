//
//  JournalViewModel.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import RxSwift
import RxCocoa

final class JournalViewModel {
    private let recordManager = RecordManagerCore()
    private let membersManager = MembersManagerCore()
    private let imageManager = ImageManagerCore()
    private let sessionManager = SessionManagerCore()
    private let monetizationManager = MonetizationManagerCore()
    
    func currentMemberHasSymptoms() -> Single<Bool> {
        getCurrentMemberSymptomsCount()
            .map { $0 > 0 }
    }

    func needPaymentForAnalyze() -> Bool {
        let hasActiveSubscription = sessionManager.getSession()?.activeSubscription ?? false
        let needPayment = monetizationManager.getMonetizationConfig()?.beforeAnalyzeSymptoms ?? false
        
        if hasActiveSubscription {
            return false
        }
        
        return needPayment
    }
    
    func memberImage() -> Driver<UIImage> {
        getMemberImage()
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func sections() -> Driver<[JournalTableSection]> {
        makeSections()
            .asDriver(onErrorJustReturn: [])
    }
    
    func currentMemberIsHuman() -> Driver<Bool> {
        getMember()
            .map { member in
                switch member.unit {
                case .me, .child, .parent, .other:
                    return true
                case .animal, .object:
                    return false
                }
            }
            .asDriver(onErrorJustReturn: false)
    }
}

// MARK: Private
private extension JournalViewModel {
    func getCurrentMemberSymptomsCount() -> Single<Int> {
        membersManager
            .rxCurrentMember()
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { [weak self] member -> Single<Int> in
                guard let this = self, let currentMember = member else {
                    return .never()
                }
                
                return this.recordManager
                    .rxGet(for: currentMember.id)
                    .map { records -> Int in
                        records.reduce(0) { count, record in
                            guard let humanRecord = record as? HumanRecord else {
                                return count
                            }
                            
                            return count + humanRecord.symptoms.count
                        }
                    }
            }
            .observeOn(MainScheduler.asyncInstance)
    }
    
    func getMemberImage() -> Observable<UIImage> {
        getMember()
            .flatMapLatest { [weak self] member -> Observable<UIImage> in
                guard let this = self else {
                    return .empty()
                }
                
                switch member.unit {
                case .me(let human), .child(let human), .parent(let human), .other(let human):
                    guard let imageKey = human.imageKey else {
                        let image = TextImageMaker().make(size: CGSize(width: 56.scale, height: 56.scale),
                                                          attributedString: String(human.name.prefix(2))
                                                            .attributed(with: TextAttributes()
                                                            .textColor(UIColor(integralRed: 208, green: 201, blue: 214))
                                                            .font(Fonts.Poppins.semiBold(size: 36.scale))
                                                            .lineHeight(41.scale)
                                                            .textAlignment(.center)),
                                                          backgroundColor: UIColor(integralRed: 243, green: 243, blue: 243))
                        
                        return Observable<UIImage?>
                            .just(image)
                            .compactMap { $0 }
                    }
                    
                    return this.imageManager
                        .rxRetrieve(key: imageKey)
                        .asObservable()
                        .compactMap { $0 }
                case .animal:
                    return Observable<UIImage?>
                        .just(UIImage(named: "Members.Animal.Default"))
                        .compactMap { $0 }
                case .object:
                    return Observable<UIImage?>
                        .just(UIImage(named: "Members.Object.Default"))
                        .compactMap { $0 }
                }
            }
    }
    
    func makeSections() -> Observable<[JournalTableSection]> {
        getMember()
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMapLatest(getRecords(member:))
            .map(sortAndMap(records:))
            .observeOn(MainScheduler.asyncInstance)
    }
    
    func getRecords(member: Member) -> Observable<[Record]> {
        Observable
            .combineLatest(
                recordManager
                    .rxGet(for: member.id)
                    .asObservable(),
                
                RecordManagerMediator.shared
                    .rxLoggedRecord
                    .asObservable()
                    .scan([Record]()) { added, new -> [Record] in
                        added + [new]
                    }
                    .startWith([]),
                
                RecordManagerMediator.shared
                    .rxRemovedRecordId
                    .asObservable()
                    .scan([Int]()) { removed, new -> [Int] in
                        removed + [new]
                    }
                    .startWith([])
            )
            .map { initial, added, removed -> [Record] in
                var result = initial + added
                
                for remove in removed {
                    result.removeAll(where: { $0.id == remove })
                }
                
                return result
            }
    }
    
    func sortAndMap(records: [Record]) -> [JournalTableSection] {
        records
            .sorted(by: {
                $0.date.compare($1.date) == .orderedDescending
            })
            .compactMap(map(record:))
    }
    
    func map(record: Record) -> JournalTableSection? {
        if let humanRecord = record as? HumanRecord {
            return map(humanRecord: humanRecord)
        }
        
        if let animalRecord = record as? AnimalRecord {
            return map(animalRecord: animalRecord)
        }
        
        if let objectRecord = record as? ObjectRecord {
            return map(objectRecord: objectRecord)
        }
        
        return nil
    }
    
    func map(humanRecord: HumanRecord) -> JournalTableSection {
        var elements = [JournalTableElement]()
        
        let jtRecord = JTReport(date: humanRecord.date,
                                temperature: humanRecord.temperature.value,
                                unit: humanRecord.temperature.unit,
                                overallFeeiling: humanRecord.overallFeeling)
        elements.append(.report(jtRecord))
        
        if !humanRecord.medicines.isEmpty {
            let tags = JTTags(style: .medicines, tags: humanRecord.medicines.map { TagViewModel(id: $0.id, name: $0.name) })
            
            elements.append(.tags(tags))
        }
        
        if !humanRecord.symptoms.isEmpty {
            let tags = JTTags(style: .symptoms, tags: humanRecord.symptoms.map { TagViewModel(id: $0.id, name: $0.name) })
            
            elements.append(.tags(tags))
        }
        
        return JournalTableSection(elements: elements)
    }
    
    func map(animalRecord: AnimalRecord) -> JournalTableSection {
        var elements = [JournalTableElement]()
        
        let jtRecord = JTReport(date: animalRecord.date,
                                temperature: animalRecord.temperature.value,
                                unit: animalRecord.temperature.unit,
                                overallFeeiling: nil)
        elements.append(.report(jtRecord))
        
        return JournalTableSection(elements: elements)
    }
    
    func map(objectRecord: ObjectRecord) -> JournalTableSection {
        var elements = [JournalTableElement]()
        
        let jtRecord = JTReport(date: objectRecord.date,
                                temperature: objectRecord.temperature.value,
                                unit: objectRecord.temperature.unit,
                                overallFeeiling: nil)
        elements.append(.report(jtRecord))
        
        return JournalTableSection(elements: elements)
    }
    
    func getMember() -> Observable<Member> {
        Observable<Member>
            .merge([
                membersManager.rxCurrentMember().asObservable().compactMap { $0 },
                MembersManagerMediator.shared.rxDidSetCurrentMember.asObservable()
            ])
    }
}
