//
//  Reminder.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 04.02.2021.
//

struct Reminder: Codable {
    let id: String
    let time: Date
    let weekday: Weekday
    let checked: Bool
}
