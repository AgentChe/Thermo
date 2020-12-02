//
//  HTMLString.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 02.12.2020.
//

import Foundation

struct HTMLString {
    let string: String
    
    var htmlAttributedString: NSAttributedString? {
        guard let data = string.data(using: .utf8) else {
            return nil
        }
        
        guard
            let attrs = try? NSMutableAttributedString(data: data,
                                                       options: [.documentType: NSAttributedString.DocumentType.html,
                                                                 .characterEncoding: String.Encoding.utf8.rawValue,],
                                                       documentAttributes: nil)
        else {
            return nil
        }
        
        attrs.addAttributes([.foregroundColor: UIColor.white], range: NSMakeRange(0, attrs.length))
        attrs.addAttributes([.font: Fonts.Poppins.regular(size: 16.scale)], range: NSMakeRange(0, attrs.length))
        
        return attrs
    }
}
