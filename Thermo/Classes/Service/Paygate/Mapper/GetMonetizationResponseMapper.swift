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
        
        return MonetizationConfig(maxFreeProfiles: data["max_free_profiles"] as? Int ?? 0,
                                  maxFreeTracking: data["max_free_trackings"] as? Int ?? 0,
                                  afterOnboarding: data["after_onboarding"] as? Bool ?? false,
                                  afterTemperatureTracking: data["after_temperature_tracking"] as? Bool ?? false)
    }
}
