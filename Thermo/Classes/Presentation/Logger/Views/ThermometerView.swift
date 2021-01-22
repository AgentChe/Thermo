//
//  TemperatureBulbView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 22.01.2021.
//

import UIKit

final class ThermometerView: UIView {
    private let gradientColors = [#colorLiteral(red: 0.8549019608, green: 0.4235294118, blue: 0.5176470588, alpha: 1).cgColor,
                                  #colorLiteral(red: 0.7843137255, green: 0.4117647059, blue: 0.6705882353, alpha: 1).cgColor,
                                  #colorLiteral(red: 0.7333333333, green: 0.431372549, blue: 0.7411764706, alpha: 1).cgColor,
                                  #colorLiteral(red: 0.631372549, green: 0.4352941176, blue: 0.8470588235, alpha: 1).cgColor,
                                  #colorLiteral(red: 0.5411764706, green: 0.4862745098, blue: 0.8549019608, alpha: 1).cgColor,
                                  #colorLiteral(red: 0.4980392157, green: 0.568627451, blue: 0.8862745098, alpha: 1).cgColor,
                                  #colorLiteral(red: 0.4235294118, green: 0.8705882353, blue: 0.9607843137, alpha: 1).cgColor]
    private let scaleColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1).withAlphaComponent(0.5)
    private let outerColor = #colorLiteral(red: 0.9137254902, green: 0.9607843137, blue: 1, alpha: 1).withAlphaComponent(0.3)
    private let progressColors = [#colorLiteral(red: 0.7019607843, green: 0.8274509804, blue: 0.9568627451, alpha: 1).cgColor, #colorLiteral(red: 0.7019607843, green: 0.8274509804, blue: 0.9568627451, alpha: 1).cgColor, #colorLiteral(red: 0.8549019608, green: 0.4235294118, blue: 0.5176470588, alpha: 1).cgColor]
    
    private let animateKey = "GradientLocationKey"
    
    let gradientLayer = CAGradientLayer()
    
    var progress: Double = 0.0 {
        didSet {
            gradientLayer.removeAllAnimations()
            let animation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.locations))
            let locations = gradientLocation(progress: progress)
            print(locations)
            animation.fromValue = gradientLayer.locations
            animation.toValue = locations
            animation.duration = 1

            gradientLayer.locations = locations
            gradientLayer.add(animation, forKey: animateKey)
            
        }
    }
    
    override func draw(_ rect: CGRect) {
        drawThermometer(for: rect)
    }
    
    func gradientLocation(progress: Double) -> [NSNumber] {
        let topProgress = max(1 - progress, 0.0)
        let reminder = max(1 - topProgress - 0.000_001, 0.0)
        
        let value = reminder / Double(gradientColors.count)
        let locations: [Double] = gradientColors.enumerated().reduce(into: []) { result, args in
            let (index, _) = args
            result.append(min(topProgress + 0.0000001 + value * Double(index + 1), 1.0))
        }
        
        let result = [0.0, topProgress, topProgress + 0.0000001] + locations
        
        return result.map { NSNumber(value: $0) }
    }
    
    private func drawThermometer(for frame: CGRect) {
        let outerLayer = CAShapeLayer()
        let scaleLayer = CAShapeLayer()
        
        let outerPath = strokePath().fit(into: frame).moveCenter(to: frame.center)
        
        outerLayer.path = outerPath.cgPath
        outerLayer.fillColor = nil
        
        let progressFrame = CGRect(
            origin: frame.origin,
            size: CGSize(width: outerPath.cgPath.boundingBox.width, height: outerPath.cgPath.boundingBox.height * 0.9)
        )
        
        let innerPath = self.innerPath().fit(into: progressFrame).moveCenter(to: frame.center)
        
        let scaleFrame = CGRect(
            x: frame.center.x,
            y: frame.origin.y + frame.height * 0.4,
            width: frame.width,
            height: frame.height * 0.319
        )
        
        let startScalePath = scalePath().fit(into: scaleFrame)
        let scalePath = startScalePath.moveCenter(to: CGPoint(x: scaleFrame.origin.x - 2 + startScalePath.cgPath.boundingBox.width / 2, y: scaleFrame.origin.y))
        
        scaleLayer.path = scalePath.cgPath
        scaleLayer.fillColor = scaleColor.cgColor
        
        gradientLayer.colors = progressColors + gradientColors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = frame
        gradientLayer.locations = gradientLocation(progress: progress)
        
        let gradientMask = CAShapeLayer()
        gradientMask.path = innerPath.cgPath
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = outerPath.cgPath
        gradientLayer.mask = gradientMask
        
        layer.mask = maskLayer
        
        layer.addSublayer(gradientLayer)
        layer.addSublayer(scaleLayer)
        layer.addSublayer(outerLayer)
        
        scalePath.fill()
        innerPath.fill()
        outerPath.fill()
    }
    
    private func scalePath() -> UIBezierPath {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 465, y: 162))
        bezierPath.addCurve(to: CGPoint(x: 465, y: 174.74), controlPoint1: CGPoint(x: 465, y: 162), controlPoint2: CGPoint(x: 465, y: 166.93))
        bezierPath.addLine(to: CGPoint(x: 457.75, y: 174.74))
        bezierPath.addCurve(to: CGPoint(x: 451.86, y: 174.32), controlPoint1: CGPoint(x: 454.99, y: 174.74), controlPoint2: CGPoint(x: 453.34, y: 174.74))
        bezierPath.addLine(to: CGPoint(x: 451.57, y: 174.26))
        bezierPath.addCurve(to: CGPoint(x: 447, y: 168.69), controlPoint1: CGPoint(x: 448.83, y: 173.41), controlPoint2: CGPoint(x: 447, y: 171.18))
        bezierPath.addCurve(to: CGPoint(x: 447, y: 168.37), controlPoint1: CGPoint(x: 447, y: 168.37), controlPoint2: CGPoint(x: 447, y: 168.37))
        bezierPath.addLine(to: CGPoint(x: 447, y: 168.05))
        bezierPath.addCurve(to: CGPoint(x: 451.57, y: 162.48), controlPoint1: CGPoint(x: 447, y: 165.56), controlPoint2: CGPoint(x: 448.83, y: 163.33))
        bezierPath.addCurve(to: CGPoint(x: 456.8, y: 162), controlPoint1: CGPoint(x: 453.06, y: 162.08), controlPoint2: CGPoint(x: 454.45, y: 162.01))
        bezierPath.addCurve(to: CGPoint(x: 457.75, y: 162), controlPoint1: CGPoint(x: 457.1, y: 162), controlPoint2: CGPoint(x: 457.41, y: 162))
        bezierPath.addCurve(to: CGPoint(x: 458.27, y: 162), controlPoint1: CGPoint(x: 457.92, y: 162), controlPoint2: CGPoint(x: 458.09, y: 162))
        bezierPath.addLine(to: CGPoint(x: 465, y: 162))
        bezierPath.addLine(to: CGPoint(x: 465, y: 162))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: 465, y: 199.74))
        bezierPath.addLine(to: CGPoint(x: 457.75, y: 199.74))
        bezierPath.addCurve(to: CGPoint(x: 451.86, y: 199.32), controlPoint1: CGPoint(x: 454.99, y: 199.74), controlPoint2: CGPoint(x: 453.34, y: 199.74))
        bezierPath.addLine(to: CGPoint(x: 451.57, y: 199.26))
        bezierPath.addCurve(to: CGPoint(x: 447, y: 193.69), controlPoint1: CGPoint(x: 448.83, y: 198.41), controlPoint2: CGPoint(x: 447, y: 196.18))
        bezierPath.addCurve(to: CGPoint(x: 447, y: 193.37), controlPoint1: CGPoint(x: 447, y: 193.37), controlPoint2: CGPoint(x: 447, y: 193.37))
        bezierPath.addLine(to: CGPoint(x: 447, y: 193.05))
        bezierPath.addCurve(to: CGPoint(x: 451.57, y: 187.48), controlPoint1: CGPoint(x: 447, y: 190.56), controlPoint2: CGPoint(x: 448.83, y: 188.33))
        bezierPath.addCurve(to: CGPoint(x: 456.8, y: 187), controlPoint1: CGPoint(x: 453.06, y: 187.08), controlPoint2: CGPoint(x: 454.45, y: 187.01))
        bezierPath.addCurve(to: CGPoint(x: 457.75, y: 187), controlPoint1: CGPoint(x: 457.1, y: 187), controlPoint2: CGPoint(x: 457.41, y: 187))
        bezierPath.addCurve(to: CGPoint(x: 458.27, y: 187), controlPoint1: CGPoint(x: 457.92, y: 187), controlPoint2: CGPoint(x: 458.09, y: 187))
        bezierPath.addLine(to: CGPoint(x: 465, y: 187))
        bezierPath.addCurve(to: CGPoint(x: 465, y: 199.74), controlPoint1: CGPoint(x: 465, y: 190.98), controlPoint2: CGPoint(x: 465, y: 195.27))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: 465, y: 224.74))
        bezierPath.addLine(to: CGPoint(x: 457.75, y: 224.74))
        bezierPath.addCurve(to: CGPoint(x: 451.86, y: 224.32), controlPoint1: CGPoint(x: 454.99, y: 224.74), controlPoint2: CGPoint(x: 453.34, y: 224.74))
        bezierPath.addLine(to: CGPoint(x: 451.57, y: 224.26))
        bezierPath.addCurve(to: CGPoint(x: 447, y: 218.69), controlPoint1: CGPoint(x: 448.83, y: 223.41), controlPoint2: CGPoint(x: 447, y: 221.18))
        bezierPath.addCurve(to: CGPoint(x: 447, y: 218.37), controlPoint1: CGPoint(x: 447, y: 218.37), controlPoint2: CGPoint(x: 447, y: 218.37))
        bezierPath.addLine(to: CGPoint(x: 447, y: 218.05))
        bezierPath.addCurve(to: CGPoint(x: 451.57, y: 212.48), controlPoint1: CGPoint(x: 447, y: 215.56), controlPoint2: CGPoint(x: 448.83, y: 213.33))
        bezierPath.addCurve(to: CGPoint(x: 456.8, y: 212), controlPoint1: CGPoint(x: 453.06, y: 212.08), controlPoint2: CGPoint(x: 454.45, y: 212.01))
        bezierPath.addCurve(to: CGPoint(x: 457.75, y: 212), controlPoint1: CGPoint(x: 457.1, y: 212), controlPoint2: CGPoint(x: 457.41, y: 212))
        bezierPath.addCurve(to: CGPoint(x: 458.27, y: 212), controlPoint1: CGPoint(x: 457.92, y: 212), controlPoint2: CGPoint(x: 458.09, y: 212))
        bezierPath.addLine(to: CGPoint(x: 465, y: 212))
        bezierPath.addCurve(to: CGPoint(x: 465, y: 224.74), controlPoint1: CGPoint(x: 465, y: 216.23), controlPoint2: CGPoint(x: 465, y: 220.51))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: 465, y: 237))
        bezierPath.addCurve(to: CGPoint(x: 465, y: 249.74), controlPoint1: CGPoint(x: 465, y: 241.46), controlPoint2: CGPoint(x: 465, y: 245.75))
        bezierPath.addLine(to: CGPoint(x: 457.75, y: 249.74))
        bezierPath.addCurve(to: CGPoint(x: 451.86, y: 249.32), controlPoint1: CGPoint(x: 454.99, y: 249.74), controlPoint2: CGPoint(x: 453.34, y: 249.74))
        bezierPath.addLine(to: CGPoint(x: 451.57, y: 249.26))
        bezierPath.addCurve(to: CGPoint(x: 447, y: 243.69), controlPoint1: CGPoint(x: 448.83, y: 248.41), controlPoint2: CGPoint(x: 447, y: 246.18))
        bezierPath.addCurve(to: CGPoint(x: 447, y: 243.37), controlPoint1: CGPoint(x: 447, y: 243.37), controlPoint2: CGPoint(x: 447, y: 243.37))
        bezierPath.addLine(to: CGPoint(x: 447, y: 243.05))
        bezierPath.addCurve(to: CGPoint(x: 451.57, y: 237.48), controlPoint1: CGPoint(x: 447, y: 240.56), controlPoint2: CGPoint(x: 448.83, y: 238.33))
        bezierPath.addCurve(to: CGPoint(x: 456.8, y: 237), controlPoint1: CGPoint(x: 453.06, y: 237.08), controlPoint2: CGPoint(x: 454.45, y: 237.01))
        bezierPath.addCurve(to: CGPoint(x: 457.75, y: 237), controlPoint1: CGPoint(x: 457.1, y: 237), controlPoint2: CGPoint(x: 457.41, y: 237))
        bezierPath.addCurve(to: CGPoint(x: 458.27, y: 237), controlPoint1: CGPoint(x: 457.92, y: 237), controlPoint2: CGPoint(x: 458.09, y: 237))
        bezierPath.addLine(to: CGPoint(x: 465, y: 237))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: 465, y: 262))
        bezierPath.addCurve(to: CGPoint(x: 465, y: 274.74), controlPoint1: CGPoint(x: 465, y: 268.9), controlPoint2: CGPoint(x: 465, y: 273.61))
        bezierPath.addLine(to: CGPoint(x: 457.75, y: 274.74))
        bezierPath.addCurve(to: CGPoint(x: 451.86, y: 274.32), controlPoint1: CGPoint(x: 454.99, y: 274.74), controlPoint2: CGPoint(x: 453.34, y: 274.74))
        bezierPath.addLine(to: CGPoint(x: 451.57, y: 274.26))
        bezierPath.addCurve(to: CGPoint(x: 447, y: 268.69), controlPoint1: CGPoint(x: 448.83, y: 273.41), controlPoint2: CGPoint(x: 447, y: 271.18))
        bezierPath.addCurve(to: CGPoint(x: 447, y: 268.37), controlPoint1: CGPoint(x: 447, y: 268.37), controlPoint2: CGPoint(x: 447, y: 268.37))
        bezierPath.addLine(to: CGPoint(x: 447, y: 268.05))
        bezierPath.addCurve(to: CGPoint(x: 451.57, y: 262.48), controlPoint1: CGPoint(x: 447, y: 265.56), controlPoint2: CGPoint(x: 448.83, y: 263.33))
        bezierPath.addCurve(to: CGPoint(x: 456.8, y: 262), controlPoint1: CGPoint(x: 453.06, y: 262.08), controlPoint2: CGPoint(x: 454.45, y: 262.01))
        bezierPath.addCurve(to: CGPoint(x: 457.75, y: 262), controlPoint1: CGPoint(x: 457.1, y: 262), controlPoint2: CGPoint(x: 457.41, y: 262))
        bezierPath.addCurve(to: CGPoint(x: 458.27, y: 262), controlPoint1: CGPoint(x: 457.92, y: 262), controlPoint2: CGPoint(x: 458.09, y: 262))
        bezierPath.addLine(to: CGPoint(x: 465, y: 262))
        bezierPath.close()
        
        return bezierPath
    }
    
    private func innerPath() -> UIBezierPath {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 359.84, y: 141.77))
        bezierPath.addCurve(to: CGPoint(x: 361.16, y: 157.54), controlPoint1: CGPoint(x: 361.16, y: 145.94), controlPoint2: CGPoint(x: 361.16, y: 149.81))
        bezierPath.addCurve(to: CGPoint(x: 361.16, y: 374.64), controlPoint1: CGPoint(x: 361.16, y: 157.54), controlPoint2: CGPoint(x: 361.16, y: 282.34))
        bezierPath.addCurve(to: CGPoint(x: 361.15, y: 375.18), controlPoint1: CGPoint(x: 361.15, y: 374.82), controlPoint2: CGPoint(x: 361.15, y: 375))
        bezierPath.addCurve(to: CGPoint(x: 368, y: 387.52), controlPoint1: CGPoint(x: 361.15, y: 380.39), controlPoint2: CGPoint(x: 363.89, y: 384.96))
        bezierPath.addLine(to: CGPoint(x: 368.35, y: 387.73))
        bezierPath.addCurve(to: CGPoint(x: 370.02, y: 388.58), controlPoint1: CGPoint(x: 368.89, y: 388.05), controlPoint2: CGPoint(x: 369.44, y: 388.33))
        bezierPath.addCurve(to: CGPoint(x: 401.28, y: 440.14), controlPoint1: CGPoint(x: 388.6, y: 398.28), controlPoint2: CGPoint(x: 401.28, y: 417.73))
        bezierPath.addCurve(to: CGPoint(x: 349.1, y: 497.98), controlPoint1: CGPoint(x: 401.28, y: 470.24), controlPoint2: CGPoint(x: 378.41, y: 494.99))
        bezierPath.addCurve(to: CGPoint(x: 344.46, y: 498.65), controlPoint1: CGPoint(x: 347.62, y: 498.42), controlPoint2: CGPoint(x: 346.06, y: 498.65))
        bezierPath.addLine(to: CGPoint(x: 342.7, y: 498.65))
        bezierPath.addCurve(to: CGPoint(x: 338.47, y: 498.1), controlPoint1: CGPoint(x: 341.25, y: 498.65), controlPoint2: CGPoint(x: 339.83, y: 498.46))
        bezierPath.addCurve(to: CGPoint(x: 285, y: 440.14), controlPoint1: CGPoint(x: 308.55, y: 495.72), controlPoint2: CGPoint(x: 285, y: 470.68))
        bezierPath.addCurve(to: CGPoint(x: 316.62, y: 388.39), controlPoint1: CGPoint(x: 285, y: 417.58), controlPoint2: CGPoint(x: 297.85, y: 398.03))
        bezierPath.addCurve(to: CGPoint(x: 326.02, y: 374.79), controlPoint1: CGPoint(x: 322.11, y: 386.31), controlPoint2: CGPoint(x: 326.02, y: 381))
        bezierPath.addCurve(to: CGPoint(x: 326, y: 374.05), controlPoint1: CGPoint(x: 326.02, y: 374.54), controlPoint2: CGPoint(x: 326.01, y: 374.29))
        bezierPath.addCurve(to: CGPoint(x: 327.15, y: 142.45), controlPoint1: CGPoint(x: 326.01, y: 148.93), controlPoint2: CGPoint(x: 326.13, y: 145.54))
        bezierPath.addLine(to: CGPoint(x: 327.32, y: 141.77))
        bezierPath.addCurve(to: CGPoint(x: 334.62, y: 133.13), controlPoint1: CGPoint(x: 328.68, y: 138.03), controlPoint2: CGPoint(x: 331.31, y: 135.01))
        bezierPath.addCurve(to: CGPoint(x: 342.7, y: 131), controlPoint1: CGPoint(x: 337.03, y: 131.76), controlPoint2: CGPoint(x: 339.8, y: 131))
        bezierPath.addLine(to: CGPoint(x: 344.46, y: 131))
        bezierPath.addCurve(to: CGPoint(x: 359.84, y: 141.77), controlPoint1: CGPoint(x: 351.34, y: 131), controlPoint2: CGPoint(x: 357.49, y: 135.3))
        bezierPath.close()
        
        return bezierPath
    }
    
    private func strokePath() -> UIBezierPath {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 183.15, y: 115.42))
        bezierPath.addCurve(to: CGPoint(x: 186.5, y: 155.57), controlPoint1: CGPoint(x: 186.5, y: 126.02), controlPoint2: CGPoint(x: 186.5, y: 135.87))
        bezierPath.addCurve(to: CGPoint(x: 186.5, y: 341.28), controlPoint1: CGPoint(x: 186.5, y: 155.57), controlPoint2: CGPoint(x: 186.5, y: 258.84))
        bezierPath.addLine(to: CGPoint(x: 186.5, y: 342))
        bezierPath.addCurve(to: CGPoint(x: 194, y: 357.52), controlPoint1: CGPoint(x: 186.72, y: 348.21), controlPoint2: CGPoint(x: 189.58, y: 353.75))
        bezierPath.addLine(to: CGPoint(x: 194.31, y: 357.78))
        bezierPath.addCurve(to: CGPoint(x: 195.07, y: 358.37), controlPoint1: CGPoint(x: 194.57, y: 357.99), controlPoint2: CGPoint(x: 194.82, y: 358.19))
        bezierPath.addCurve(to: CGPoint(x: 227.42, y: 425.21), controlPoint1: CGPoint(x: 214.78, y: 373.98), controlPoint2: CGPoint(x: 227.42, y: 398.12))
        bezierPath.addCurve(to: CGPoint(x: 142.21, y: 510.42), controlPoint1: CGPoint(x: 227.42, y: 472.27), controlPoint2: CGPoint(x: 189.27, y: 510.42))
        bezierPath.addCurve(to: CGPoint(x: 57, y: 425.21), controlPoint1: CGPoint(x: 95.15, y: 510.42), controlPoint2: CGPoint(x: 57, y: 472.27))
        bezierPath.addCurve(to: CGPoint(x: 86.68, y: 360.58), controlPoint1: CGPoint(x: 57, y: 399.36), controlPoint2: CGPoint(x: 68.51, y: 376.21))
        bezierPath.addCurve(to: CGPoint(x: 96.96, y: 342.33), controlPoint1: CGPoint(x: 92.84, y: 356.84), controlPoint2: CGPoint(x: 96.96, y: 350.07))
        bezierPath.addLine(to: CGPoint(x: 96.96, y: 342))
        bezierPath.addCurve(to: CGPoint(x: 99.93, y: 117.14), controlPoint1: CGPoint(x: 97.04, y: 133.47), controlPoint2: CGPoint(x: 97.36, y: 124.93))
        bezierPath.addLine(to: CGPoint(x: 100.35, y: 115.42))
        bezierPath.addCurve(to: CGPoint(x: 139.16, y: 88), controlPoint1: CGPoint(x: 106.3, y: 99.07), controlPoint2: CGPoint(x: 121.78, y: 88.15))
        bezierPath.addLine(to: CGPoint(x: 139.51, y: 88))
        bezierPath.addLine(to: CGPoint(x: 143.99, y: 88))
        bezierPath.addCurve(to: CGPoint(x: 183.15, y: 115.42), controlPoint1: CGPoint(x: 161.51, y: 88), controlPoint2: CGPoint(x: 177.16, y: 98.96))
        bezierPath.close()
        outerColor.setFill()
        
        return bezierPath
    }
}

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: size.width / 2.0, y: size.height / 2.0)
    }
}
extension CGPoint {
    func vector(to p1:CGPoint) -> CGVector{
        return CGVector(dx: p1.x - x, dy: p1.y - y)
    }
}

extension UIBezierPath {
    func moveCenter(to: CGPoint) -> Self {
        let bound = cgPath.boundingBox
        let center = bounds.center
        
        let zeroedTo = CGPoint(x: to.x - bound.origin.x, y: to.y - bound.origin.y)
        let vector = center.vector(to: zeroedTo)
        
        return offset(to: CGSize(width: vector.dx, height: vector.dy))
    }
    
    func offset(to offset: CGSize) -> Self{
        let t = CGAffineTransform(translationX: offset.width, y: offset.height)
        
        return applyCentered(transform: t)
    }
    
    func fit(into: CGRect) -> Self{
        let test = cgPath.boundingBox
        let bounds = CGRect(x: test.origin.x, y: test.origin.y, width: test.width + lineWidth + 10, height: test.height + lineWidth + 10)
        
        let sw = into.size.width / bounds.width
        let sh = into.size.height / bounds.height
        let factor = min(sw, max(sh, 0.0))
        
        return scale(x: factor, y: factor)
    }
    
    func scale(x: CGFloat, y: CGFloat) -> Self {
        let scale = CGAffineTransform(scaleX: x, y: y)
        return applyCentered(transform: scale)
    }
    
    func applyCentered(transform: @autoclosure () -> CGAffineTransform ) -> Self {
        let bound  = cgPath.boundingBox
        let center = CGPoint(x: bound.midX, y: bound.midY)
        var xform  = CGAffineTransform.identity
        
        xform = xform.concatenating(CGAffineTransform(translationX: -center.x, y: -center.y))
        xform = xform.concatenating(transform())
        xform = xform.concatenating(CGAffineTransform(translationX: center.x, y: center.y))
        apply(xform)
        
        return self
    }
}
