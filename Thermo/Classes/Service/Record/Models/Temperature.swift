//
//  Temperature.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.10.2020.
//

struct Temperature: Hashable {
    let value: Double
    let unit: TemperatureUnit
}

extension Temperature: Codable {}
