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
    
    func hasActiveSubscription() -> Bool {
        sessionManager.getSession()?.activeSubscription ?? false
    }
    
    func memberImage() -> Driver<UIImage> {
        getMemberImage()
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func sections() -> Driver<[JournalTableSection]> {
        makeSections()
            .asDriver(onErrorJustReturn: [])
    }
}

// MARK: Private
private extension JournalViewModel {
    func getMemberImage() -> Observable<UIImage> {
        getMember()
            .flatMapLatest { [weak self] member -> Observable<UIImage> in
                guard let this = self else {
                    return .empty()
                }
                
                switch member.unit {
                case .me(let human), .child(let human), .parent(let human), .other(let human):
                    return this.imageManager
                        .rxRetrieve(key: human.imageKey)
                        .asObservable().compactMap { $0 }
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
    
    func getMember() -> Observable<Member> {
        Observable<Member>
            .merge([
                membersManager.rxCurrentMember().asObservable().compactMap { $0 },
                MembersManagerMediator.shared.rxDidSetCurrentMember.asObservable()
            ])
    }
}
