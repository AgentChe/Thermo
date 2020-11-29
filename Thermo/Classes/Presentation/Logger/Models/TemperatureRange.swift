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
    
    let topRedColor: (min: CGFloat, max: CGFloat)
    let topGreenColor: (min: CGFloat, max: CGFloat)
    let topBlueColor: (min: CGFloat, max: CGFloat)
    let bottomRedColor: (min: CGFloat, max: CGFloat)
    let bottomGreenColor: (min: CGFloat, max: CGFloat)
    let bottomBlueColor: (min: CGFloat, max: CGFloat)
    
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
            
            topRedColor = (129, 211)
            topGreenColor = (140, 106)
            topBlueColor = (225, 143)
            bottomRedColor = (108, 173)
            bottomGreenColor = (200, 106)
            bottomBlueColor = (230, 197)
            
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
            
            topRedColor = (253, 253)
            topGreenColor = (158, 192)
            topBlueColor = (112, 111)
            bottomRedColor = (253, 251)
            bottomGreenColor = (191, 131)
            bottomBlueColor = (113, 83)
            
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
            
            topRedColor = (254, 253)
            topGreenColor = (226, 191)
            topBlueColor = (89, 4)
            bottomRedColor = (253, 253)
            bottomGreenColor = (204, 170)
            bottomBlueColor = (86, 81)
        }
    }
}
