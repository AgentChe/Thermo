//
//  OnboardingSliderIndicatorsView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 03.02.2021.
//

import UIKit

final class OnboardingSliderIndicatorsView: UIView {
    var count: Int = 0 {
        didSet {
            reset()
        }
    }
    
    var index: Int = 0 {
        didSet {
            updateColor()
        }
    }
    
    private var indicators = [UIView]()
    
    private var isConfigurated = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard !isConfigurated && frame.width > 0 && frame.height > 0 else {
            return
        }
        
        updateIndicators()
        updateColor()
        
        isConfigurated = true
    }
}

// MARK: Private
private extension OnboardingSliderIndicatorsView {
    func reset() {
        indicators.forEach { $0.removeFromSuperview() }
        indicators = []
        
        isConfigurated = false
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func updateIndicators() {
        let slidesContainerWidth = CGFloat(count) * 10.scale + CGFloat((count - 1)) * 20.scale
        let equalWidths = frame.width - slidesContainerWidth
        var slideIndicatorX = equalWidths / 2
        
        for _ in 0..<count {
            let slideIndicator = CircleView()
            slideIndicator.frame.size = CGSize(width: 10.scale, height: 10.scale)
            slideIndicator.frame.origin = CGPoint(x: slideIndicatorX, y: 0)
            indicators.append(slideIndicator)
            addSubview(slideIndicator)
            slideIndicatorX += 20.scale
        }
    }
    
    func updateColor() {
        indicators.enumerated().forEach { [weak self] stub in
            guard let this = self else {
                return
            }
            
            let (index, indicator) = stub
            
            indicator.backgroundColor = this.index == index ? UIColor(integralRed: 148, green: 165, blue: 225) : UIColor(integralRed: 196, green: 196, blue: 196)
        }
    }
}
