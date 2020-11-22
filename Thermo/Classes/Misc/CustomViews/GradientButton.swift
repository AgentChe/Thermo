//
//  GradientButton.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 22.11.2020.
//

import UIKit

class GradientButton: UIButton {
    override class var layerClass: AnyClass {
        CAGradientLayer.self
    }

    var gradientLayer: CAGradientLayer {
        layer as! CAGradientLayer
    }
}
