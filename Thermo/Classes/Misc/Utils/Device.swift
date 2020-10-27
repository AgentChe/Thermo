//
//  Device.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 26.10.2020.
//

import Foundation.NSLocale
import UIKit

extension UIDevice {
    static var deviceLanguageCode: String? {
        guard let mainPreferredLanguage = Locale.preferredLanguages.first else {
            return nil
        }
        
        return Locale(identifier: mainPreferredLanguage).languageCode
    }
    
    static var appVersion: String? {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
}
