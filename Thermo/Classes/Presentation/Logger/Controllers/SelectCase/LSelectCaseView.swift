//
//  LSelectCaseView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 15.01.2021.
//

import UIKit

final class LSelectCaseView: UIView {
    lazy var container = makeContainer()
    lazy var withAppCell = makeCell(icon: "LoggerType.WithApp", title: "LoggerType.WithApp")
    lazy var appleHealthCell = makeCell(icon: "LoggerType.AppleHealth", title: "LoggerType.AppleHealth")
    lazy var manuallyCell = makeCell(icon: "LoggerType.EnterManually", title: "LoggerType.EnterManually")
    lazy var button = makeButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension LSelectCaseView {
    func initialize() {
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
}

// MARK: Make constraints
private extension LSelectCaseView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            withAppCell.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            withAppCell.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            withAppCell.topAnchor.constraint(equalTo: container.topAnchor, constant: 30.scale),
            withAppCell.heightAnchor.constraint(equalToConstant: 57.scale)
        ])
        
        NSLayoutConstraint.activate([
            appleHealthCell.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            appleHealthCell.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            appleHealthCell.topAnchor.constraint(equalTo: withAppCell.bottomAnchor),
            appleHealthCell.heightAnchor.constraint(equalToConstant: 57.scale)
        ])
        
        NSLayoutConstraint.activate([
            manuallyCell.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            manuallyCell.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            manuallyCell.topAnchor.constraint(equalTo: appleHealthCell.bottomAnchor),
            manuallyCell.heightAnchor.constraint(equalToConstant: 57.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 36.scale),
            button.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -36.scale),
            button.topAnchor.constraint(equalTo: manuallyCell.bottomAnchor, constant: 20.scale),
            button.heightAnchor.constraint(equalToConstant: 56.scale),
            button.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -40.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension LSelectCaseView {
    func makeContainer() -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = true 
        view.layer.cornerRadius = 24.scale
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell(icon: String, title: String) -> LSCCell {
        let view = LSCCell()
        view.iconView.image = UIImage(named: icon)
        view.label.attributedText = title.localized
            .attributed(with: TextAttributes()
                            .textColor(UIColor.black)
                            .font(Fonts.Poppins.semiBold(size: 17.scale))
                            .letterSpacing(-0.4.scale))
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeButton() -> GradientButton {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.Poppins.semiBold(size: 17.scale))
            .lineHeight(22.scale)
            .textAlignment(.center)
        
        let view = GradientButton()
        view.gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        view.gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        view.gradientLayer.colors = [
            UIColor(integralRed: 255, green: 165, blue: 2).cgColor,
            UIColor(integralRed: 255, green: 99, blue: 72).cgColor
        ]
        view.layer.cornerRadius = 28.scale
        view.setAttributedTitle("LoggerType.Button".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
