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
    
    func elements() -> Driver<[JournalTableElement]> {
        let member = Observable
            .merge([
                membersManager.rxCurrentMember().asObservable().compactMap { $0 },
                MembersManagerMediator.shared.rxDidSetCurrentMember.asObservable()
            ])
        
        
        return member
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
            .map { list -> [JournalTableElement] in
                list
                    .sorted(by: {
                        $0.date.compare($1.date) == .orderedDescending
                    })
                    .map {
                        JournalTableElement(date: $0.date,
                                            temperature: $0.value,
                                            unit: $0.unit,
                                            overallFeeiling: $0.overallFeeling)
                }
            }
            .observeOn(MainScheduler.asyncInstance)
            .asDriver(onErrorJustReturn: [])
    }
}
