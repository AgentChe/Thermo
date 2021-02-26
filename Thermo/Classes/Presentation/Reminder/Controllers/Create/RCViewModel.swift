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
        case created, paygate
    }
    
    lazy var create = PublishRelay<(Date, Weekday)>()
    
    private lazy var reminderManager = ReminderManagerCore()
    private lazy var sessionManager = SessionManagerCore()
    private lazy var monetizationManager = MonetizationManagerCore()
    
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
                
                guard !this.needPayment() else {
                    return .just(.paygate)
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
    
    func needPayment() -> Bool {
        let config = monetizationManager.getMonetizationConfig()?.reminders ?? false
        let hasActiveSubscription = sessionManager.getSession()?.activeSubscription ?? false
        
        if hasActiveSubscription {
            return false
        }
        
        return config
    }
}
