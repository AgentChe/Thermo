//
//  ReminderManagerDelegate.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 02.11.2020.
//

protocol ReminderManagerDelegate: class {
    func reminderManagerDidAdd(reminder: Reminder)
    func reminderManagerDidChange(reminder: Reminder)
    func reminderManagerDidRemove(reminder: Reminder)
}

extension ReminderManagerDelegate {
    func reminderManagerDidAdd(reminder: Reminder) {}
    func reminderManagerDidChange(reminder: Reminder) {}
    func reminderManagerDidRemove(reminder: Reminder) {}
}
