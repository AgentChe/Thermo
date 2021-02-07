//
//  RCViewModel.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 04.02.2021.
//

import RxSwift
import RxCocoa

final class RCViewModel {
    enum Step {
        case created
    }
    
    lazy var create = PublishRelay<(Date, Weekday)>()
    
    private lazy var reminderManager = ReminderManagerCore()
    
    lazy var step = makeStep()
}

// MARK: Private
private extension RCViewModel {
    func makeStep() -> Driver<Step> {
        create
            .flatMapLatest { [weak self] stub -> Single<Step> in
                guard let this = self else {
                    return .never()
                }
                
                let (time, weekday) = stub
                
                return this.reminderManager
                    .rxAddRemindAt(time: time, weekday: weekday)
                    .map { reminder -> Step in
                        .created
                    }
            }
            .asDriver(onErrorDriveWith: .empty())
    }
}
