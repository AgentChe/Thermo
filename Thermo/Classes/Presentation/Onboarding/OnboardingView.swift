//
//  OnboardingView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 26.10.2020.
//

import RxSwift

final class OnboardingView: GradientView {
    enum Step: Int {
        case trackTemperaturePurpose = 0
        case trackTemperatureImportant = 1
    }
    
    lazy var scrollView = makeScrollView()
    lazy var button = makeButton()
    lazy var trackTemperaturePurpose = TrackTemperaturePurpose()
    lazy var trackTemperatureImportant = TrackTemperatureImportant()
    
    var step = Step.trackTemperaturePurpose {
        didSet {
            updateButton()
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
private extension OnboardingView {
    func configure() {
        gradientLayer.colors = [
            UIColor(integralRed: 221, green: 217, blue: 221).cgColor,
            UIColor(integralRed: 254, green: 234, blue: 235).cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
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
        
        updateButton()
    }
    
    func updateButton() {
        let title: String
        
        switch step {
        case .trackTemperaturePurpose:
            title = "Continue".localized
        case .trackTemperatureImportant:
            title = "OK".localized
        }
        
        let attrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.Poppins.semiBold(size: 17.scale))
            .lineHeight(22.scale)
        
        button.setAttributedTitle(title.attributed(with: attrs), for: .normal)
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
            trackTemperaturePurpose,
            trackTemperatureImportant
        ]
    }
}

// MARK: Make constraints
private extension OnboardingView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 34.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -34.scale),
            button.heightAnchor.constraint(equalToConstant: 56.scale),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -80.scale : -40.scale)
        ])
    }
}

// MARK: Lazy initalization
private extension OnboardingView {
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.backgroundColor = UIColor.clear
        view.isScrollEnabled = false
        view.isPagingEnabled = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let view = UIButton()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 28.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
