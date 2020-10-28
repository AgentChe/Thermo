//
//  LoggerTemperatureView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import UIKit

final class LoggerTemperatureView: GradientView {
    lazy var titleLabel = makeTitleLabel()
    lazy var valueLabel = makeValueLabel()
    lazy var continueButton = makeContinueButton()
    
    var range: TemperatureRange? {
        didSet {
            start()
        }
    }
    
    var value: Double = 0 {
        didSet {
            update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension LoggerTemperatureView {
    func start() {
        gradientLayer.colors = [
            UIColor(integralRed: 127, green: 145, blue: 226).cgColor,
            UIColor(integralRed: 108, green: 22, blue: 245).cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        value = range?.initial ?? 0
    }
    
    func update() {
        let attrs = TextAttributes()
            .font(Fonts.OpenSans.bold(size: 68.scale))
            .textColor(UIColor.white)
            .textAlignment(.center)
        
        valueLabel.attributedText = String(format: "%.1f", value).attributed(with: attrs)
    }
}

// MARK: Make constraints
private extension LoggerTemperatureView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 191.scale)
        ])
        
        NSLayoutConstraint.activate([
            valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            valueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 450.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.widthAnchor.constraint(equalToConstant: 180.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 56.scale),
            continueButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -80.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension LoggerTemperatureView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.OpenSans.bold(size: 34.scale))
            .textAlignment(.center)
            .lineHeight(41.scale)
    
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "TemperatureLogger.Temperature.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeValueLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.Poppins.semiBold(size: 17.scale))
            .lineHeight(22.scale)
        
        let view = UIButton()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 20.scale
        view.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
