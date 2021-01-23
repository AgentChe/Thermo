//
//  EMView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 22.01.2021.
//

import UIKit

final class EMView: GradientView {
    enum Step: Int {
        case placeholder = 0
        case temperature = 1
        case overallFeeling = 2
    }
    
    lazy var scrollView = makeScrollView()
    lazy var placeholderView = EMPlaceholderView()
    lazy var temperatureView = LAHTemperatureView()
    lazy var feelView = LoggerFeelView()
    
    var step = Step.placeholder {
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
private extension EMView {
    func configure() {
        backgroundColor = UIColor.white
        
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
            placeholderView,
            temperatureView,
            feelView
        ]
    }
}

// MARK: Make constraints
private extension EMView {
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
private extension EMView {
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
}
