//
//  PulseToTemperature.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 05.02.2021.
//

// TODO
final class PulseToTemperature {
    static func calculate(pulse: Double, unit: TemperatureUnit) -> Double {
        let range = TemperatureRange(for: .celsius)
        
        switch unit {
        case .celsius:
            return celsius(pulse: pulse, range: range)
        case .fahrenheit:
            return (celsius(pulse: pulse, range: range) * 1.8) + 32
        }
    }
}

// MARK: Private
private extension PulseToTemperature {
    static func celsius(pulse: Double, range: TemperatureRange) -> Double {
        // 1 bmp == 0.1 градус
        // pulse 70 -> 36.6
        
        let temperature = (pulse - range.normalBMP) * 0.1 + range.normal
        
        if temperature > range.max {
            return range.max
        } else if temperature < range.min {
            return range.min
        }
        
        let divisor = pow(10.0, Double(1))
        let rounded = (temperature * divisor).rounded() / divisor
        
        return rounded
    }
}
