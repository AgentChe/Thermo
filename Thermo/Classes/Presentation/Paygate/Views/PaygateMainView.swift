//
//  PaygateMainView.swift
//  SleepWell
//
//  Created by Andrey Chernyshev on 12/06/2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class PaygateMainView: GradientView {
    lazy var restoreButton = makeRestoreButton()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var leftOptionView = makeOptionView()
    lazy var rightOptionView = makeOptionView()
    lazy var continueButton = makeContinueButton()
    lazy var lockImageView = makeLockIconView()
    lazy var termsOfferLabel = makeTermsOfferLabel()
    lazy var purchasePreloaderView = makePreloaderView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configure()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(paygate: PaygateMainOffer) {
        titleLabel.attributedText = paygate.title
        subTitleLabel.attributedText = paygate.subTitle
        continueButton.setAttributedTitle(paygate.button, for: .normal)
        termsOfferLabel.attributedText = paygate.subButton
        restoreButton.setAttributedTitle(paygate.restore, for: .normal)
        
        let options = paygate.options?.prefix(2) ?? []
        
        if let leftOption = options.first {
            leftOptionView.isHidden = false
            leftOptionView.isSelected = true
            leftOptionView.setup(option: leftOption)
        } else {
            leftOptionView.isHidden = true
        }
        
        if options.count > 1, let rightOption = options.last {
            rightOptionView.isHidden = false
            rightOptionView.setup(option: rightOption)
        } else {
            rightOptionView.isHidden = true
        }
    }
}

// MARK: Private
private extension PaygateMainView {
    func configure() {
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        gradientLayer.colors = [
            UIColor(integralRed: 180, green: 0, blue: 160).cgColor,
            UIColor(integralRed: 102, green: 150, blue: 241).cgColor
        ]
    }
}

// MARK: Make constraints
private extension PaygateMainView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -11.scale),
            titleLabel.bottomAnchor.constraint(equalTo: subTitleLabel.topAnchor, constant: ScreenSize.isIphoneXFamily ? -44.scale : -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            subTitleLabel.bottomAnchor.constraint(equalTo: leftOptionView.topAnchor, constant: ScreenSize.isIphoneXFamily ? -44.scale : -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            leftOptionView.widthAnchor.constraint(equalTo: rightOptionView.widthAnchor),
            leftOptionView.heightAnchor.constraint(equalToConstant: 185.scale),
            leftOptionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            leftOptionView.trailingAnchor.constraint(equalTo: rightOptionView.leadingAnchor, constant: -13.scale),
            leftOptionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -185.scale : -130.scale)
        ])
        
        NSLayoutConstraint.activate([
            rightOptionView.heightAnchor.constraint(equalToConstant: 185.scale),
            rightOptionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            rightOptionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -185.scale : -130.scale)
        ])
        
        NSLayoutConstraint.activate([
            lockImageView.widthAnchor.constraint(equalToConstant: 12.scale),
            lockImageView.heightAnchor.constraint(equalToConstant: 16.scale),
            lockImageView.trailingAnchor.constraint(equalTo: termsOfferLabel.leadingAnchor, constant: -10.scale),
            lockImageView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: ScreenSize.isIphoneXFamily ? -18.scale : -6.scale)
        ])
        
        NSLayoutConstraint.activate([
            termsOfferLabel.centerYAnchor.constraint(equalTo: lockImageView.centerYAnchor),
            termsOfferLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.heightAnchor.constraint(equalToConstant: 50.scale),
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -63.scale : -50.scale)
        ])
        
        NSLayoutConstraint.activate([
            restoreButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -25.scale : -10.scale),
            restoreButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            restoreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            restoreButton.heightAnchor.constraint(equalToConstant: 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            purchasePreloaderView.centerYAnchor.constraint(equalTo: continueButton.centerYAnchor),
            purchasePreloaderView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension PaygateMainView {
    func makeRestoreButton() -> UIButton {
        let view = UIButton()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.alpha = 0
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let view = UILabel()
        view.alpha = 0
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeOptionView() -> PaygateOptionView {
        let view = PaygateOptionView()
        view.alpha = 0
        view.layer.cornerRadius = 8.scale
        view.layer.borderWidth = 2.scale
        view.layer.borderColor = UIColor.white.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let view = UIButton()
        view.isHidden = true
        view.backgroundColor = .white
        view.layer.cornerRadius = 28.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLockIconView() -> UIImageView {
        let view = UIImageView()
        view.alpha = 0
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Paygate.MainOffer.Lock")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTermsOfferLabel() -> UILabel {
        let view = UILabel()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloaderView() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.style = .whiteLarge
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
