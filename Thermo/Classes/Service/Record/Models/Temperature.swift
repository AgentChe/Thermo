//
//  Temperature.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.10.2020.
//

struct Temperature {
    let value: Double
    let unit: TemperatureUnit
}

// MARK: Codable
extension Temperature: Codable {}


// MARK: Hashable
extension Temperature: Hashable {}
