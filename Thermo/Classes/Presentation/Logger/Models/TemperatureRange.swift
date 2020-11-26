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
    let step: Double
    let normal: Double
    let unit: TemperatureUnit
    
    init(for unit: Member) {
        self.unit = unit.temperatureUnit
        
        switch unit.unit {
        case .me, .child, .parent, .other:
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
        case .animal:
            step = 0.5
            
            switch unit.temperatureUnit {
            case .celsius:
                min = 5
                max = 45.0
                normal = 30.0
            case .fahrenheit:
                min = 41
                max = 113
                normal = 6
            }
        case .object:
            step = 0.5
            
            switch unit.temperatureUnit {
            case .celsius:
                min = -30
                max = 100
                normal = 10
            case .fahrenheit:
                min = -22
                max = 212
                normal = 50
            }
        }
    }
}
