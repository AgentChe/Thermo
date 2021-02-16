//
//  Member.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.10.2020.
//

struct Member: Hashable {
    let id: Int
    let temperatureUnit: TemperatureUnit
}

// MARK: Codable
extension Member: Codable {}
