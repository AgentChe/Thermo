//
//  TextImageMaker.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 03.12.2020.
//

import Foundation

final class TextImageMaker {
    func make(size: CGSize, attributedString: NSAttributedString, backgroundColor: UIColor) -> UIImage? {
        let label = UILabel()
        label.frame.origin = CGPoint(x: 0, y: 0)
        label.frame.size = size
        label.attributedText = attributedString
        label.backgroundColor = backgroundColor
        
        UIGraphicsBeginImageContext(size)
        
        if let currentContext = UIGraphicsGetCurrentContext() {
            label.layer.render(in: currentContext)
            return UIGraphicsGetImageFromCurrentImageContext()
        } else {
            return nil 
        }
    }
}
