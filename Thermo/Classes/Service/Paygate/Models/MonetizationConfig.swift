//
//  MonetizationConfig.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.11.2020.
//

struct MonetizationConfig: Hashable {
    // Флаги отображение после действия
    let afterOnboarding: Bool
    let afterTemperatureTracking: Bool
    // Флаги платности фич
    let reminders: Bool
    let symptoms: Bool
    let medicines: Bool
    let temperature: Bool
}

// MARK: Codable
extension MonetizationConfig: Codable {}
