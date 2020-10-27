//
//  Toast.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.10.2020.
//

import UIKit
import NotificationBannerSwift

final class Toast {}

// MARK: Management

extension Toast {
    static func notify(with text: String, style: BannerStyle) {
        let attributedText = text.attributed(with: TextAttributes()
            .font(UIFont.systemFont(ofSize: 17.scale, weight: .bold))
            .textColor(UIColor.black)
            .textAlignment(.center))
        
        NotificationBanner(attributedTitle: attributedText, style: style).show()
    }
    
    static func notify(with attributedText: NSAttributedString, style: BannerStyle) {
        NotificationBanner(attributedTitle: attributedText, style: style).show()
    }
}
