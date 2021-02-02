//
//  WeekdayLocalizable.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 02.11.2020.
//

final class WeekdayLocalizable {
    static func localize(weekday: Weekday) -> String {
        switch weekday {
        case .monday:
            return "Monday".localized
        case .tuesday:
            return "Tuesday".localized
        case .wednesday:
            return "Wednesday".localized
        case .thursday:
            return "Thursday".localized
        case .friday:
            return "Friday".localized
        case .saturday:
            return "Saturday".localized
        case .sunday:
            return "Sunday".localized
        }
    }
}
