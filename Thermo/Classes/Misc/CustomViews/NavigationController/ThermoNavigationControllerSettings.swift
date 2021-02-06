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
                                           tintColor: UIColor.black,
                                           titleTextAttrributes: TextAttributes()
                                            .textColor(UIColor.black)
                                            .font(Fonts.Poppins.semiBold(size: 17.scale))
                                            .textAlignment(.center)
                                            .dictionary)
    }
}
