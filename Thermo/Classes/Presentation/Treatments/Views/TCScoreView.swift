//
//  TCScoreView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 02.12.2020.
//

import UIKit

class TCScoreView: UIView {
    var score: CGFloat = 0 {
        didSet {
            progressLayer.strokeEnd = score / 100
        }
    }
    
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    
    private var size = CGFloat(50.scale)
    private var progressColor = UIColor(integralRed: 80, green: 179, blue: 190)
    
    init(size: CGFloat, progressColor: UIColor) {
        super.init(frame: .zero)
        
        self.size = size
        self.progressColor = progressColor
        
        createCircularPath()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension TCScoreView {
    func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: size / 2, y: size / 2),
                                        radius: size / 2,
                                        startAngle: -.pi / 2,
                                        endAngle: 3 * .pi / 2,
                                        clockwise: true)
        
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 5.scale
        circleLayer.strokeColor = UIColor(integralRed: 228, green: 228, blue: 228).cgColor
        layer.addSublayer(circleLayer)
        
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 5.scale
        progressLayer.strokeEnd = score / 100
        progressLayer.strokeColor = progressColor.cgColor
        layer.addSublayer(progressLayer)
    }
}
