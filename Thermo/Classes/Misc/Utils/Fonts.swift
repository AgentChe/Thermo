//
//  Fonts.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 26.10.2020.
//

import UIKit

struct Fonts {
    // MARK: OpenSans
    struct OpenSans {
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "OpenSans-Bold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "OpenSans-Regular", size: size)!
        }
        
        static func semiBold(size: CGFloat) -> UIFont {
            UIFont(name: "OpenSans-SemiBold", size: size)!
        }
    }
    
    // MARK: Poppins
    struct Poppins {
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "Poppins-Bold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "Poppins-Regular", size: size)!
        }
        
        static func semiBold(size: CGFloat) -> UIFont {
            UIFont(name: "Poppins-SemiBold", size: size)!
        }
    }
}
