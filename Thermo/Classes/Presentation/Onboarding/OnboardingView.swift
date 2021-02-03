//
//  OnboardingView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 26.10.2020.
//

import RxSwift

final class OnboardingView: GradientView {
    lazy var slider = makeSlider()
    lazy var indicatorsView = makeIndicatorsView()
    lazy var button = makeButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension OnboardingView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor),
            slider.topAnchor.constraint(equalTo: topAnchor),
            slider.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            indicatorsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            indicatorsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            indicatorsView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -192.scale),
            indicatorsView.heightAnchor.constraint(equalToConstant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 180.scale),
            button.heightAnchor.constraint(equalToConstant: 56.scale),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50.scale)
        ])
    }
}

// MARK: Lazy initalization
private extension OnboardingView {
    func makeSlider() -> OnboardingSlider {
        let view = OnboardingSlider()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeIndicatorsView() -> OnboardingSliderIndicatorsView {
        let view = OnboardingSliderIndicatorsView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .font(Fonts.Poppins.semiBold(size: 17.scale))
            .textColor(UIColor.white)
            .lineHeight(22.scale)
        
        let view = UIButton()
        view.layer.cornerRadius = 28.scale
        view.backgroundColor = UIColor(integralRed: 148, green: 165, blue: 225)
        view.setAttributedTitle("Next".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
