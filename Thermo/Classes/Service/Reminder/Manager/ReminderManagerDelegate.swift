//
//  ReminderManagerDelegate.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 02.11.2020.
//

protocol ReminderManagerDelegate: class {
    func reminderManagerDidAdd(reminderTime: ReminderTime)
    func reminderManagerDidChange(time: ReminderTime)
    func reminderManagerDidChange(weekday: ReminderWeekday)
}

extension ReminderManagerDelegate {
    func reminderManagerDidAdd(reminderTime: ReminderTime) {}
    func reminderManagerDidChange(time: ReminderTime) {}
    func reminderManagerDidChange(weekday: ReminderWeekday) {}
}
