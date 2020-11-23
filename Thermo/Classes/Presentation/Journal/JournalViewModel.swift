//
//  JournalViewModel.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import RxSwift
import RxCocoa

final class JournalViewModel {
    private let temperatureManager = TemperatureManagerCore()
    private let membersManager = MembersManagerCore()
    private let imageManager = ImageManagerCore()
    private let sessionManager = SessionManagerCore()
    
    func hasActiveSubscription() -> Bool {
        sessionManager.getSession()?.activeSubscription ?? false
    }
    
    func memberImage() -> Driver<UIImage> {
        getMember()
            .flatMapLatest { [weak self] member -> Observable<UIImage> in
                guard let this = self else {
                    return .empty()
                }
                
                return this.imageManager
                    .rxRetrieve(key: member.imageKey)
                    .asObservable()
                    .compactMap { $0 }
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func sections() -> Driver<[JournalTableSection]> {
        getMember()
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMapLatest { [weak self] member -> Observable<[Temperature]> in
                guard let this = self else {
                    return .empty()
                }
                
                return Observable
                    .combineLatest(
                        this.temperatureManager
                            .rxGet(for: member.id)
                            .asObservable(),
                        
                        TemperatureManagerMediator.shared
                            .rxDidLoggedTemperature
                            .asObservable()
                            .scan([Temperature]()) { added, new -> [Temperature] in
                                added + [new]
                            }
                            .startWith([]),
                        
                        TemperatureManagerMediator.shared
                            .rxDidRemovedTemperatureId
                            .asObservable()
                            .scan([Int]()) { removed, new -> [Int] in
                                removed + [new]
                            }
                            .startWith([])
                    )
                    .map { initial, added, removed -> [Temperature] in
                        var result = initial + added
                        
                        for remove in removed {
                            result.removeAll(where: { $0.id == remove })
                        }
                        
                        return result
                    }
            }
            .map { list -> [JournalTableSection] in
                list
                    .sorted(by: {
                        $0.date.compare($1.date) == .orderedDescending
                    })
                    .map { temperature -> JournalTableSection in
                        var elements = [JournalTableElement]()
                        
                        let report = JTReport(date: temperature.date,
                                              temperature: temperature.value,
                                              unit: temperature.unit,
                                              overallFeeiling: temperature.overallFeeling)
                        elements.append(.report(report))
                        
                        if !temperature.medicines.isEmpty {
                            let tags = JTTags(style: .medicines, tags: temperature.medicines.map { TagViewModel(id: $0.id, name: $0.name) })
                            
                            elements.append(.tags(tags))
                        }
                        
                        if !temperature.symptoms.isEmpty {
                            let tags = JTTags(style: .symptoms, tags: temperature.symptoms.map { TagViewModel(id: $0.id, name: $0.name) })
                            
                            elements.append(.tags(tags))
                        }
                        
                        return JournalTableSection(elements: elements)
                }
            }
            .observeOn(MainScheduler.asyncInstance)
            .asDriver(onErrorJustReturn: [])
    }
}

// MARK: Private
private extension JournalViewModel {
    func getMember() -> Observable<Member> {
        Observable<Member>
            .merge([
                membersManager.rxCurrentMember().asObservable().compactMap { $0 },
                MembersManagerMediator.shared.rxDidSetCurrentMember.asObservable()
            ])
    }
}
