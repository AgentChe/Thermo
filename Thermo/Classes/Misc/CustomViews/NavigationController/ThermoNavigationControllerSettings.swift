//
//  ThermoNavigationControllerSettings.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import UIKit

struct ThermoNavigationControllerSettings {
    let backgroundImage: UIImage
    let shadowImage: UIImage
    let isTranslucent: Bool
    let tintColor: UIColor
    let titleTextAttrributes: [NSAttributedString.Key: Any]
}

// MARK: Make

extension ThermoNavigationControllerSettings {
    static func `default`() -> ThermoNavigationControllerSettings {
        ThermoNavigationControllerSettings(backgroundImage: UIImage(),
                                           shadowImage: UIImage(),
                                           isTranslucent: true,
                                           tintColor: UIColor(red: 233 / 255, green: 233 / 255, blue: 233 / 255, alpha: 1),
                                           titleTextAttrributes: TextAttributes()
                                            .textColor(UIColor(red: 233 / 255, green: 233 / 255, blue: 233 / 255, alpha: 1))
                                            .font(Fonts.Poppins.semiBold(size: 17.scale))
                                            .textAlignment(.center)
                                            .dictionary)
    }
}
