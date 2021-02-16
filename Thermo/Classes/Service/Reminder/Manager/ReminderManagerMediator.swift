//
//  ReminderManagerMediator.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 04.02.2021.
//

import RxCocoa

final class ReminderManagerMediator {
    static let shared = ReminderManagerMediator()
    
    private let addedTrigger = PublishRelay<Reminder>()
    private let changedTrigger = PublishRelay<Reminder>()
    private let removedTrigger = PublishRelay<Reminder>()
    
    private var delegates = [Weak<ReminderManagerDelegate>]()
    
    private init() {}
}

// MARK: API
extension ReminderManagerMediator {
    func notifyAboutAdded(reminder: Reminder) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.reminderManagerDidAdd(reminder: reminder)
            }
            
            self?.addedTrigger.accept(reminder)
        }
    }
    
    func notifyAboutChanged(reminder: Reminder) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.reminderManagerDidChange(reminder: reminder)
            }
            
            self?.changedTrigger.accept(reminder)
        }
    }
    
    func notifyAboutRemoved(reminder: Reminder) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.reminderManagerDidRemove(reminder: reminder)
            }
            
            self?.removedTrigger.accept(reminder)
        }
    }
}

// MARK: Triggers(Rx)
extension ReminderManagerMediator {
    var rxAdded: Signal<Reminder> {
        addedTrigger.asSignal()
    }
    
    var rxChaned: Signal<Reminder> {
        changedTrigger.asSignal()
    }
    
    var rxRemoved: Signal<Reminder> {
        removedTrigger.asSignal()
    }
}

// MARK: Observer
extension ReminderManagerMediator {
    func add(delegate: ReminderManagerDelegate) {
        let weakly = delegate as AnyObject
        delegates.append(Weak<ReminderManagerDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }

    func remove(delegate: ReminderManagerDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === delegate }) {
            delegates.remove(at: index)
        }
    }
}
