//
//  StringExtension.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 26.10.2020.
//

import Foundation

extension String {
    static func choosePluralForm(byNumber: Int, one: String, two: String, many: String) -> String {
        var result = many
        let number = byNumber % 100
        
        if (number < 10 || number >= 20) {
            if (number % 10 == 1) {
                result = one
            }
            if (number % 10 > 1 && number % 10 < 5) {
                result = two
            }
        }
        return result
    }
    
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
