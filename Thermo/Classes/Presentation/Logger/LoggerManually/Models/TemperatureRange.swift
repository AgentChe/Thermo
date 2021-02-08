//
//  TemperatureRange.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 08.02.2021.
//

import Foundation

struct TemperatureRange {
    let min: Double
    let max: Double
    let step: Double
    let normal: Double
    let unit: TemperatureUnit
    
    init(for unit: Member) {
        self.unit = unit.temperatureUnit
        
        step = 0.1
        
        switch unit.temperatureUnit {
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
