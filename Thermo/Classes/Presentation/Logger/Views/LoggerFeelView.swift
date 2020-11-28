//
//  LoggerFeelView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 21.11.2020.
//

import UIKit

final class LoggerFeelView: GradientView {
    lazy var titleLabel = makeTitleLabel()
    lazy var overallFeelingView = makeOverallFeelingView()
    lazy var symptomsView = makeSymtomsView()
    lazy var medicinesView = makeMedicinesView()
    lazy var saveButton = makeSaveButton()
    
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
private extension LoggerFeelView {
    func configure() {
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        gradientLayer.colors = [
            UIColor(integralRed: 200, green: 0, blue: 100).cgColor,
            UIColor(integralRed: 100, green: 150, blue: 200).cgColor
        ]
    }
}

// MARK: Make constraints
private extension LoggerFeelView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 114.scale : 60.scale)
        ])
        
        NSLayoutConstraint.activate([
            overallFeelingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            overallFeelingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            overallFeelingView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale),
            overallFeelingView.heightAnchor.constraint(equalToConstant: 127.scale)
        ])
        
        NSLayoutConstraint.activate([
            symptomsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            symptomsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            symptomsView.topAnchor.constraint(equalTo: overallFeelingView.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 44.scale : 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            medicinesView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            medicinesView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            medicinesView.topAnchor.constraint(equalTo: symptomsView.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 44.scale : 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.widthAnchor.constraint(equalToConstant: 180.scale),
            saveButton.heightAnchor.constraint(equalToConstant: 56.scale),
            saveButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -33.scale : -15.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension LoggerFeelView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.OpenSans.bold(size: 34.scale))
            .textAlignment(.center)
            .lineHeight(41.scale)
    
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "TemperatureLogger.Feeling.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeOverallFeelingView() -> OverallFeelingView {
        let view = OverallFeelingView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSymtomsView() -> LoggerSelectionView {
        let view = LoggerSelectionView()
        view.titleLabel.attributedText = "TemperatureLogger.Feeling.Symptoms.Title".localized
            .attributed(with: TextAttributes()
                            .font(Fonts.Poppins.bold(size: 14.scale))
                            .lineHeight(21.scale)
                            .textColor(UIColor.white)
                            .letterSpacing(0.5.scale))
        view.leftIconLabel.attributedText = "📝"
            .attributed(with: TextAttributes()
                            .lineHeight(20.scale)
                            .font(Fonts.Poppins.regular(size: 15.scale)))
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeMedicinesView() -> LoggerSelectionView {
        let view = LoggerSelectionView()
        view.titleLabel.attributedText = "TemperatureLogger.Feeling.Medicines.Title".localized
            .attributed(with: TextAttributes()
                            .font(Fonts.Poppins.bold(size: 14.scale))
                            .lineHeight(21.scale)
                            .textColor(UIColor.white)
                            .letterSpacing(0.5.scale))
        view.leftIconLabel.attributedText = "💊"
            .attributed(with: TextAttributes()
                            .lineHeight(20.scale)
                            .font(Fonts.Poppins.regular(size: 15.scale)))
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSaveButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.Poppins.semiBold(size: 17.scale))
            .lineHeight(22.scale)
        
        let view = UIButton()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 28.scale
        view.setAttributedTitle("TemperatureLogger.Feeling.Button".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
