//
//  LWAOnboardingView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 05.02.2021.
//

import UIKit

final class LWAOnboardingView: UIView {
    lazy var button = makeButton()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var stackView = makeStackView()
    private lazy var warningContainerView = makeWarningContainerView()
    private lazy var warningLabel = makeWarningLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension LWAOnboardingView {
    func initialize() {
        backgroundColor = UIColor.white
        [
            "LWA.Onboarding.Step1",
            "LWA.Onboarding.Step2",
            "LWA.Onboarding.Step3"
        ]
        .enumerated().forEach { index, value in
            makeStepView(step: index + 1, message: value.localized)
        }
    }
}

// MARK: Make constraints
private extension LWAOnboardingView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 120.scale : 60.scale),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30.scale),
            titleLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -60.scale)
        ])
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30.scale),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -21.scale),
            stackView.bottomAnchor.constraint(equalTo: warningContainerView.topAnchor, constant: -40.scale)
        ])
        
        NSLayoutConstraint.activate([
            warningContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30.scale),
            warningContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30.scale)
        ])
        
        NSLayoutConstraint.activate([
            warningLabel.topAnchor.constraint(equalTo: warningContainerView.topAnchor, constant: 20.scale),
            warningLabel.bottomAnchor.constraint(equalTo: warningContainerView.bottomAnchor, constant: -20.scale),
            warningLabel.leadingAnchor.constraint(equalTo: warningContainerView.leadingAnchor, constant: 16.scale),
            warningLabel.trailingAnchor.constraint(equalTo: warningContainerView.trailingAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -50.scale : -30.scale),
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 97.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -97.scale),
            button.heightAnchor.constraint(equalToConstant: 56.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension LWAOnboardingView {
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(.white)
            .font(Fonts.Poppins.semiBold(size: 17.scale))
            .lineHeight(22.scale)
        
        let view = UIButton()
        view.layer.cornerRadius = 28.scale
        view.backgroundColor = UIColor(integralRed: 148, green: 165, blue: 225)
        view.setAttributedTitle("LWA.Onboarding.Measure".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        let attr = TextAttributes()
            .font(Fonts.Poppins.bold(size: 34.scale))
            .lineHeight(41.scale)
            .textColor(.black)
        
        view.attributedText = "LWA.Onboarding.HowToMeasure".localized.attributed(with: attr)
        addSubview(view)
        return view
    }
    
    func makeWarningContainerView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 28.scale
        view.backgroundColor = UIColor(integralRed: 246, green: 246, blue: 246)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeWarningLabel() -> UILabel {
        let fontSize = 15.scale
        let font = Fonts.Poppins.regular(size: fontSize)
        let image = UIImage(named: "LWA.Warning")!
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        
        var baselineOffset: CGFloat {
            let dividend =  image.size.height - fontSize
            return dividend / 2 - font.descender / 2
        }
        
        let attr = TextAttributes()
            .font(font)
            .lineHeight(26.scale)
            .textColor(.black)
            .baselineOffset(baselineOffset)
        
        let imageString = NSAttributedString(attachment: imageAttachment)
        let stringAttributes = ("  \("LWA.Onboarding.Warning".localized)").attributed(with: attr)
        
        let attrs = NSMutableAttributedString()
        attrs.append(imageString)
        attrs.append(stringAttributes)
        
        let view = UILabel()
        view.attributedText = attrs
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        warningContainerView.addSubview(view)
        return view
    }
    
    func makeStackView() -> UIStackView {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 15.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeStepView(step: Int, message: String) {
        let view = LWAOnboardingStepView()
        view.setup(step: step, message: message)
        view.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(view)
    }
}
