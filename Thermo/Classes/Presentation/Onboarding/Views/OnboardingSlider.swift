//
//  OnboardingSlider.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 03.02.2021.
//

import UIKit

final class OnboardingSlider: UIView {
    weak var delegate: OnboardingSliderDelegate?
    
    private lazy var scrollView = UIScrollView()
    private lazy var slides = [OnboardingSlideView]()
    
    private var models: [OnboardingSlide] = []
    
    private var isConfigurated = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard !isConfigurated && frame.size != .zero && !models.isEmpty else {
            return
        }
        
        configure()
        
        isConfigurated = true
    }
}

// MARK: API
extension OnboardingSlider {
    func setup(models: [OnboardingSlide]) {
        slides.forEach { $0.removeFromSuperview() }
        slides = []
        
        subviews.forEach { $0.removeFromSuperview() }
        
        isConfigurated = false
        
        self.models = models
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func scroll(to index: Int) {
        guard slides.indices.contains(index) else {
            return
        }
        
        let frame = slides[index].frame
        
        scrollView.scrollRectToVisible(frame, animated: true)
    }
}

// MARK: UIScrollViewDelegate
extension OnboardingSlider: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let slideIndex = Int(round(scrollView.contentOffset.x / frame.width))
        
        delegate?.onboardingSlider(changed: slideIndex)
    }
}

// MARK: Private
private extension OnboardingSlider {
    func configure() {
        scrollView.frame.size = CGSize(width: frame.width, height: frame.height)
        scrollView.frame.origin = CGPoint(x: 0, y: 0)
        scrollView.contentSize = CGSize(width: frame.width * CGFloat(models.count), height: frame.height)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        addSubview(scrollView)
        
        for (index, model) in models.enumerated() {
            let slide = OnboardingSlideView()
            slide.frame.size = CGSize(width: frame.width, height: frame.height)
            slide.frame.origin = CGPoint(x: frame.width * CGFloat(index), y: 0)
            slide.setup(model: model)
            slides.append(slide)
            scrollView.addSubview(slide)
        }
    }
}
