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
    func addRemindAt(time: Date, checked: Bool) -> ReminderTime?
    @discardableResult func set(timeId: String, checked: Bool) -> Bool
    @discardableResult func set(weekday: Weekday, checked: Bool) -> Bool
    func getRemindersTime() -> [ReminderTime]
    func getRemindersWeekday() -> [ReminderWeekday]
    
    // MARK: API(Rx)
    func rxAddRemindAt(time: Date, checked: Bool) -> Single<ReminderTime?>
    func rxSet(timeId: String, checked: Bool) -> Single<Bool>
    func rxSet(weekday: Weekday, checked: Bool) -> Single<Bool>
    func rxObtainRemindersTime() -> Single<[ReminderTime]>
    func rxObtainRemindersWeekday() -> Single<[ReminderWeekday]>
    
    // MARK: Triggers(Rx)
    var rxDidAdd: Signal<ReminderTime> { get }
    var rxDidChangeTime: Signal<ReminderTime> { get }
    var rxDidChangeWeekday: Signal<ReminderWeekday> { get }
    
    // MARK: Observer
    func add(observer: ReminderManagerDelegate)
    func remove(observer: ReminderManagerDelegate)
}
