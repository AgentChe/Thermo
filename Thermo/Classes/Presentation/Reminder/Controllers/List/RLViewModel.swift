//
//  RLViewModel.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 04.02.2021.
//

import RxSwift
import RxCocoa

final class RLViewModel {
    lazy var switchReminder = PublishRelay<(String, Bool)>()
    lazy var removeReminder = PublishRelay<Reminder>()
    
    private lazy var reminderManager = ReminderManagerCore()
    private lazy var reminderNotificationsManager = ReminderNotificationsManager()
    
    lazy var elements = Driver
        .merge([makeElements(), subscribeOnRemindersChanges()])
    
    func subscriveOnChangesAndUpdateNotificationsTriggers() -> Signal<Void> {
        Signal
            .merge(
                ReminderManagerMediator.shared.rxChaned.map { reminder in Void() },
                ReminderManagerMediator.shared.rxAdded.map { reminder in Void() },
                ReminderManagerMediator.shared.rxRemoved.map { reminder in Void() }
            )
            .flatMapLatest { [weak self] void -> Signal<Void> in
                guard let this = self else {
                    return .never()
                }
                
                return this.reminderManager
                    .rxObtainReminders()
                    .flatMap { reminders in
                        this.reminderNotificationsManager
                            .rxPost(reminders: reminders)
                    }
                    .asSignal(onErrorJustReturn: Void())
            }
    }
}

// MARK: Private
private extension RLViewModel {
    func makeElements() -> Driver<[RLTableElement]> {
        reminderManager
            .rxObtainReminders()
            .asDriver(onErrorJustReturn: [])
            .flatMap { [weak self] cached -> Driver<[RLTableElement]> in
                guard let this = self else {
                    return .empty()
                }
                
                return Signal
                    .merge([
                        ReminderManagerMediator.shared.rxChaned.map { reminder in Void() },
                        ReminderManagerMediator.shared.rxAdded.map { reminder in Void() },
                        ReminderManagerMediator.shared.rxRemoved.map { reminder in Void() }
                    ])
                    .flatMapLatest { void -> Signal<[Reminder]> in
                        this.reminderManager
                            .rxObtainReminders()
                            .asSignal(onErrorJustReturn: [])
                    }
                    .startWith(cached)
                    .map { reminders -> [RLTableElement] in
                        reminders
                            .map { reminder -> RLTableElement in
                                RLTableElement(reminder: reminder) { isOn in
                                    this.switchReminder.accept((reminder.id, isOn))
                                }
                            }
                    }
                    .asDriver(onErrorJustReturn: [])
            }
    }
    
    func subscribeOnRemindersChanges() -> Driver<[RLTableElement]> {
        Driver
            .merge([
                switchReminder
                    .flatMap { [weak self] stub -> Driver<[RLTableElement]> in
                        guard let this = self else {
                            return .empty()
                        }
                        
                        let (id, checked) = stub
                        
                        return this.reminderManager
                            .rxSet(id: id, checked: checked)
                            .flatMap { bool -> Single<[RLTableElement]> in
                                .never()
                            }
                            .asDriver(onErrorJustReturn: [])
                    }
                    .asDriver(onErrorJustReturn: []),
                
                removeReminder
                    .flatMap { [weak self] reminder -> Driver<[RLTableElement]> in
                        guard let this = self else {
                            return .empty()
                        }
                        
                        return this.reminderManager
                            .rxRemove(reminder: reminder)
                            .flatMap { void -> Single<[RLTableElement]> in
                                .never()
                            }
                            .asDriver(onErrorJustReturn: [])
                    }
                    .asDriver(onErrorJustReturn: [])
            ])
    }
}
