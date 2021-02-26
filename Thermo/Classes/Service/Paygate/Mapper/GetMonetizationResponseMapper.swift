//
//  GetMonetizationResponseMapper.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.11.2020.
//

final class GetMonetizationResponseMapper {
    static func map(from response: Any) -> MonetizationConfig? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any]
        else {
            return nil
        }
        
        return MonetizationConfig(afterOnboarding: data["paygate_after_onboarding"] as? Bool ?? false,
                                  afterTemperatureTracking: data["paygate_after_temperature_tracking"] as? Bool ?? false,
                                  reminders: data["reminders"] as? Bool ?? false,
                                  symptoms: data["symptoms"] as? Bool ?? false,
                                  medicines: data["meds"] as? Bool ?? false,
                                  temperature: data["temperature"] as? Bool ?? false)
    }
}
