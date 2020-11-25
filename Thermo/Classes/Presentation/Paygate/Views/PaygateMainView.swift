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
    lazy var infoCell1 = makeInfoCell(image: "Paygate.InfoCell1", title: "Paygate.Item1")
    lazy var infoCell2 = makeInfoCell(image: "Paygate.InfoCell2", title: "Paygate.Item2")
    lazy var infoCell3 = makeInfoCell(image: "Paygate.InfoCell3", title: "Paygate.Item3")
    lazy var infoCell4 = makeInfoCell(image: "Paygate.InfoCell4", title: "Paygate.Item4")
    lazy var leftOptionView = makeOptionView()
    lazy var rightOptionView = makeOptionView()
    lazy var continueButton = makeContinueButton()
    lazy var lockImageView = makeLockIconView()
    lazy var securedLabel = makeSecuredLabel()
    lazy var termsAndPolicyLabel = makeTermsAndPolicyLabel()
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
    
    @objc
    private func termsAndPolicyTapped(sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel, let text = label.text as NSString? else {
            return
        }
        
        let termsRange = text.range(of: "Paygate.TermsOfUse".localized)
        let policyRange = text.range(of: "Paygate.PrivacyPolicy".localized)
        
        var url: URL?

        if sender.didTapAttributedTextInLabel(label: label, inRange: termsRange) {
            url = URL(string: GlobalDefinitions.termsOfServiceUrl)
        } else if sender.didTapAttributedTextInLabel(label: label, inRange: policyRange) {
            url = URL(string: GlobalDefinitions.privacyPolicyUrl)
        }
        
        guard let openUrl = url else {
            return
        }
        
        UIApplication.shared.open(openUrl, options: [:])
    }
}

// MARK: Make constraints
private extension PaygateMainView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -11.scale),
            titleLabel.bottomAnchor.constraint(equalTo: infoCell1.topAnchor, constant: ScreenSize.isIphoneXFamily ? -44.scale : -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            restoreButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 45.scale : 29.scale),
            restoreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            restoreButton.heightAnchor.constraint(equalToConstant: 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            infoCell1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 37.scale),
            infoCell1.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.scale),
            infoCell1.bottomAnchor.constraint(equalTo: infoCell2.topAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            infoCell2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 37.scale),
            infoCell2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.scale),
            infoCell2.bottomAnchor.constraint(equalTo: infoCell3.topAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            infoCell3.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 37.scale),
            infoCell3.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.scale),
            infoCell3.bottomAnchor.constraint(equalTo: infoCell4.topAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            infoCell4.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 37.scale),
            infoCell4.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.scale),
            infoCell4.bottomAnchor.constraint(equalTo: leftOptionView.topAnchor, constant: ScreenSize.isIphoneXFamily ? -44.scale : -16.scale)
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
            lockImageView.trailingAnchor.constraint(equalTo: securedLabel.leadingAnchor, constant: -10.scale),
            lockImageView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: ScreenSize.isIphoneXFamily ? -18.scale : -6.scale)
        ])
        
        NSLayoutConstraint.activate([
            securedLabel.centerYAnchor.constraint(equalTo: lockImageView.centerYAnchor),
            securedLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.heightAnchor.constraint(equalToConstant: 50.scale),
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -63.scale : -50.scale)
        ])
        
        NSLayoutConstraint.activate([
            termsAndPolicyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.scale),
            termsAndPolicyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.scale),
            termsAndPolicyLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25.scale)
        ])
        
        NSLayoutConstraint.activate([
            purchasePreloaderView.centerYAnchor.constraint(equalTo: continueButton.centerYAnchor),
            purchasePreloaderView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension PaygateMainView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.Poppins.bold(size: 28.scale))
            .lineHeight(41.scale)
        
        let view = UILabel()
        view.attributedText = "Paygate.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeInfoCell(image: String, title: String) -> PaygateMainInfoCell {
        let view = PaygateMainInfoCell()
        view.emojiView.image = UIImage(named: image)
        view.title = title.localized
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeOptionView() -> PaygateOptionView {
        let view = PaygateOptionView()
        view.alpha = 0
        view.isHidden = true
        view.layer.cornerRadius = 8.scale
        view.layer.borderWidth = 2.scale
        view.layer.borderColor = UIColor.white.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 21, green: 21, blue: 34))
            .font(Fonts.Poppins.semiBold(size: 16.scale))
            .lineHeight(22.scale)
        
        let view = UIButton()
        view.setAttributedTitle("Paygate.BuyButton".localized.attributed(with: attrs), for: .normal)
        view.isHidden = true
        view.backgroundColor = .white
        view.layer.cornerRadius = 28.scale
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = UIColor(integralRed: 209, green: 107, blue: 152).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLockIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Paygate.MainOffer.Lock")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSecuredLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.Poppins.semiBold(size: 13.scale))
            .lineHeight(19.5.scale)
            .letterSpacing(-0.6.scale)
        
        let view = UILabel()
        view.attributedText = "Paygate.Secured".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeRestoreButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.Poppins.regular(size: 13.scale))
            .lineHeight(19.5.scale)
            .letterSpacing(-0.6.scale)
        
        let view = UIButton()
        view.setAttributedTitle("Paygate.RestoreButton".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTermsAndPolicyLabel() -> UILabel {
        let attrs = TextAttributes()
            .font(Fonts.Poppins.regular(size: 13.scale))
            .lineHeight(19.5.scale)
            .letterSpacing(-0.6.scale)
            .textColor(UIColor.white)
            .textAlignment(.center)
            .dictionary
        
        var underlineAtts = attrs
        underlineAtts[.underlineStyle] = NSUnderlineStyle.single.rawValue
        
        let terms = NSAttributedString(string: "Paygate.TermsOfUse".localized, attributes: underlineAtts)
        let and = NSAttributedString(string: "Paygate.And".localized, attributes: attrs)
        let policy = NSAttributedString(string: "Paygate.PrivacyPolicy".localized, attributes: underlineAtts)
        
        let attributedText = NSMutableAttributedString()
        attributedText.append(terms)
        attributedText.append(and)
        attributedText.append(policy)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(termsAndPolicyTapped(sender:)))
        
        let view = UILabel()
        view.attributedText = attributedText
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
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
