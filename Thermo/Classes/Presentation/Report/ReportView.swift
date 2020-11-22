//
//  ReportView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 22.11.2020.
//

import UIKit

final class ReportView: UIView {
    lazy var closeButton = makeCloseButton()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var emailField = makeEmailField()
    lazy var invalidEmailView = makeInvalidEmailView()
    lazy var sendButton = makeSendButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ReportView {
    func configure() {
        backgroundColor = UIColor.white
        
        invalidEmailView.isHidden = true
    }
}

// MARK: Make constraints
private extension ReportView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 44.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 44.scale),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 13.scale),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -9.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 71.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            emailField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            emailField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            emailField.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 32.scale),
            emailField.heightAnchor.constraint(equalToConstant: 58.scale)
        ])
        
        NSLayoutConstraint.activate([
            invalidEmailView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            invalidEmailView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            invalidEmailView.topAnchor.constraint(equalTo: emailField.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            sendButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 34.scale),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -34.scale),
            sendButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 355.scale : 300.scale),
            sendButton.heightAnchor.constraint(equalToConstant: 56.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ReportView {
    func makeCloseButton() -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: "Report.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .font(Fonts.Poppins.bold(size: 28.scale))
            .lineHeight(34.scale)
            .textColor(UIColor(integralRed: 21, green: 21, blue: 34))
        
        let view = UILabel()
        view.attributedText = "Report.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .font(Fonts.Poppins.regular(size: 13.scale))
            .lineHeight(22.scale)
            .textColor(UIColor(integralRed: 153, green: 153, blue: 153))
        
        let view = UILabel()
        view.attributedText = "Report.SubTitle".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeEmailField() -> UITextField {
        let view = UITextField()
        view.layer.borderWidth = 1.81.scale
        view.layer.borderColor = UIColor(integralRed: 214, green: 216, blue: 231).cgColor
        view.layer.cornerRadius = 10.scale
        view.backgroundColor = UIColor.clear
        view.textColor = UIColor(integralRed: 160, green: 163, blue: 189)
        view.font = Fonts.Poppins.regular(size: 16.scale)
        view.placeholder = "Report.EmailFieldPlaceholder".localized
        
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: 58.scale, height: 58.scale) )
        let iconView  = UIImageView(frame: CGRect(x: 21.scale, y: 19.5.scale, width: 22.scale, height: 22.scale))
        iconView.image =  UIImage(named: "Report.EmailIcon")
        outerView.addSubview(iconView)
        view.leftViewMode = .always
        view.leftView = outerView
        
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeInvalidEmailView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        let attrs = TextAttributes()
            .font(Fonts.Poppins.regular(size: 14.scale))
            .lineHeight(16.scale)
            .textColor(UIColor(integralRed: 223, green: 50, blue: 12))
        
        let label = UILabel()
        label.attributedText = "Report.InvalidEmail".localized.attributed(with: attrs)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Report.EmailError")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 12.scale),
            imageView.heightAnchor.constraint(equalToConstant: 12.scale),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 2.scale),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2.scale)
        ])
        
        return view
    }
    
    func makeSendButton() -> GradientButton {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.Poppins.semiBold(size: 17.scale))
            .lineHeight(22.scale)
        
        let view = GradientButton()
        view.setAttributedTitle("Report.ButtonTitle".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 28.scale
        view.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        view.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.gradientLayer.colors = [
            UIColor(integralRed: 255, green: 165, blue: 2).cgColor,
            UIColor(integralRed: 255, green: 99, blue: 72).cgColor
        ]
        view.translatesAutoresizingMaskIntoConstraints = false 
        addSubview(view)
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Report.ButtonArrow")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 20.scale),
            imageView.heightAnchor.constraint(equalToConstant: 16.scale),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30.scale),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }
}
