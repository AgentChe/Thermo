//
//  LAHTemperatureView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 18.01.2021.
//

import UIKit

final class LAHTemperatureView: GradientView {
    lazy var titleLabel = makeTitleLabel()
    lazy var thermometerView = makeThermometerView()
    lazy var valueLabel = makeValueLabel()
    lazy var continueButton = makeContinueButton()
    
    var range: TemperatureRange?
    
    var value: Double = 0 {
        didSet {
            update()
        }
    }
    
    private lazy var valueLabelBottomConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension LAHTemperatureView {
    func initialize() {
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        gradientLayer.colors = [
            UIColor(integralRed: 127, green: 145, blue: 226).cgColor,
            UIColor(integralRed: 108, green: 222, blue: 245).cgColor
        ]
    }
    
    func update() {
        guard value > 0 else {
            titleLabel.text = "LAH.Title1".localized
            valueLabel.text = "LAH.ValueEmpty".localized
            valueLabelBottomConstraint.constant = -105.scale
            continueButton.isHidden = true
            thermometerView.progress = 0
            
            valueLabel.layoutIfNeeded()
            
            return
        }
        
        guard let range = self.range else {
            return
        }
        
        let unit: String
        switch range.unit {
        case .fahrenheit:
            unit = "Fahrenheit".localized
        case .celsius:
            unit = "Celsius".localized
        }
        
        titleLabel.text = "LAH.Title2".localized
        valueLabel.text = String(format: "%.1f %@", value, unit)
        valueLabelBottomConstraint.constant = -158.scale
        continueButton.isHidden = false
        thermometerView.progress = (value - range.min) / (range.max - range.min)
        
        valueLabel.layoutIfNeeded()
    }
}

// MARK: Make constraints
private extension LAHTemperatureView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 100.scale : 100.scale)
        ])
        
        NSLayoutConstraint.activate([
            thermometerView.widthAnchor.constraint(equalToConstant: 170.scale),
            thermometerView.heightAnchor.constraint(equalToConstant: 422.scale),
            thermometerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            thermometerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20.scale)
        ])
        
        valueLabelBottomConstraint = valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -158.scale)
        NSLayoutConstraint.activate([
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            valueLabelBottomConstraint
        ])
        
        NSLayoutConstraint.activate([
            continueButton.widthAnchor.constraint(equalToConstant: 180.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 56.scale),
            continueButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -40.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension LAHTemperatureView {
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
    
    func makeThermometerView() -> ThermometerView {
        let view = ThermometerView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeValueLabel() -> UILabel {
        let view = UILabel()
        view.font = Fonts.Poppins.semiBold(size: 41.scale)
        view.textColor = UIColor.white
        view.textAlignment = .center
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
        view.layer.cornerRadius = 28.scale
        view.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
