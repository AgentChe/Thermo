//
//  Temperature.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.10.2020.
//

struct Temperature {
    let id: Int
    let member: Member
    let value: Double
    let unit: TemperatureUnit
    let overallFeeling: OverallFeeling
    let date: Date
}

extension Temperature: Codable {}
