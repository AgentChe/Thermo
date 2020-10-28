//
//  LoggerView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import UIKit

final class LoggerView: UIView {
    enum Step: Int {
        case temperature = 0
        case overallFeeling = 1
    }
    
    lazy var scrollView = makeScrollView()
    lazy var loggerTemperatureView = LoggerTemperatureView()
    lazy var overallFeelingView = makeOverallFeelingView()
    
    var step = Step.temperature {
        didSet {
            scroll()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension LoggerView {
    func configure() {
        contentViews()
            .enumerated()
            .forEach { index, view in
                scrollView.addSubview(view)
                
                view.frame.origin = CGPoint(x: UIScreen.main.bounds.width * CGFloat(index), y: 0)
                view.frame.size = CGSize(width: UIScreen.main.bounds.width,
                                         height: UIScreen.main.bounds.height)
            }
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(contentViews().count),
                                        height: UIScreen.main.bounds.height)
    }
    
    func scroll() {
        let index = step.rawValue
        
        guard contentViews().indices.contains(index) else {
            return
        }
        
        let frame = contentViews()[index].frame
        
        scrollView.scrollRectToVisible(frame, animated: true)
    }
    
    func contentViews() -> [UIView] {
        [
            loggerTemperatureView,
            overallFeelingView
        ]
    }
}

// MARK: Make constraints
private extension LoggerView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension LoggerView {
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.backgroundColor = UIColor.clear
        view.isScrollEnabled = false
        view.isPagingEnabled = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeOverallFeelingView() -> OverallFeelingView {
        let view = OverallFeelingView()
        view.gradientLayer.colors = [
            UIColor(integralRed: 255, green: 229, blue: 212).cgColor,
            UIColor(integralRed: 248, green: 183, blue: 203).cgColor
        ]
        view.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        view.gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
        return view
    }
}
