//
//  ReminderManager.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 02.11.2020.
//

import RxSwift
import RxCocoa

protocol ReminderManager: class {
    // MARK: API
    func addRemindAt(time: Date, weekday: Weekday) -> Reminder?
    @discardableResult func set(id: String, checked: Bool) -> Bool
    func getReminders() -> [Reminder]
    func remove(reminder: Reminder)
    
    // MARK: API(Rx)
    func rxAddRemindAt(time: Date, weekday: Weekday) -> Single<Reminder?>
    func rxSet(id: String, checked: Bool) -> Single<Bool>
    func rxObtainReminders() -> Single<[Reminder]>
    func rxRemove(reminder: Reminder) -> Single<Void>
}
