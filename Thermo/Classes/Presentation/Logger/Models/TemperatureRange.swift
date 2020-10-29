//
//  TemperatureRange.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import Foundation

struct TemperatureRange {
    let min: Double
    let max: Double
    let normal: Double
    let unit: TemperatureUnit
    
    init(unit: TemperatureUnit) {
        self.unit = unit
        
        switch unit {
        case .celsius:
            min = 34.0
            max = 42.0
            normal = 36.6
        case .fahrenheit:
            min = 93.2
            max = 107.6
            normal = 97.88
        }
    }
}
