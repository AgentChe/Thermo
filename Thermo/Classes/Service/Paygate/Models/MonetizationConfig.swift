//
//  MonetizationConfig.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.11.2020.
//

struct MonetizationConfig: Hashable {
    let maxFreeProfiles: Int
    let maxFreeTracking: Int
    let afterOnboarding: Bool
    let afterTemperatureTracking: Bool
    let beforeAnalyzeSymptoms: Bool
}

// MARK: Codable
extension MonetizationConfig: Codable {}
