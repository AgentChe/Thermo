//
//  Reminders.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 02.11.2020.
//

struct Reminders: Codable {
    let times: [ReminderTime]
    let weekdays: [ReminderWeekday]
}
