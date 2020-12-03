//
//  TrackTemperatureImportant.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.10.2020.
//

import UIKit

final class TrackTemperatureImportant: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var cell1 = makeCell(image: "Onboarding.TrackTemperatureImportant.Cell1",
                              text: "Onboarding.TrackTemperatureImportant.Cell1")
    lazy var cell2 = makeCell(image: "Onboarding.TrackTemperatureImportant.Cell2",
                              text: "Onboarding.TrackTemperatureImportant.Cell2")
    lazy var cell3 = makeCell(image: "Onboarding.TrackTemperatureImportant.Cell3",
                              text: "Onboarding.TrackTemperatureImportant.Cell3")
    lazy var cell4 = makeCell(image: "Onboarding.TrackTemperatureImportant.Cell4",
                              text: "Onboarding.TrackTemperatureImportant.Cell4")
    lazy var cell5 = makeCell(image: "Onboarding.TrackTemperatureImportant.Cell5",
                              text: "Onboarding.TrackTemperatureImportant.Cell5")
    lazy var button = makeButton()
    lazy var bottomLineLabel = makeBottomLineLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension TrackTemperatureImportant {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 120.scale : 60.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48.scale),
            cell1.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48.scale),
            cell1.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 36.scale : 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48.scale),
            cell2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48.scale),
            cell2.topAnchor.constraint(equalTo: cell1.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell3.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48.scale),
            cell3.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48.scale),
            cell3.topAnchor.constraint(equalTo: cell2.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell4.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48.scale),
            cell4.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48.scale),
            cell4.topAnchor.constraint(equalTo: cell3.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell5.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48.scale),
            cell5.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48.scale),
            cell5.topAnchor.constraint(equalTo: cell4.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 34.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -34.scale),
            button.heightAnchor.constraint(equalToConstant: 56.scale),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -62.scale : -36.scale)
        ])
        
        NSLayoutConstraint.activate([
            bottomLineLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.scale),
            bottomLineLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.scale),
            bottomLineLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -18.scale : -9.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TrackTemperatureImportant {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.Poppins.bold(size: 34.scale))
            .lineHeight(37.scale)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.TrackTemperatureImportant.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell(image: String, text: String) -> OnbrdIInfoCell {
        let attrs = TextAttributes()
            .lineHeight(18.scale)
            .letterSpacing(-0.4.scale)
            .textColor(UIColor(integralRed: 50, green: 50, blue: 52))
            .font(Fonts.Poppins.semiBold(size: 13.scale))
    
        let view = OnbrdIInfoCell()
        view.imageView.image = UIImage(named: image)
        view.imageView.contentMode = .scaleAspectFit
        view.label.attributedText = text.localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.Poppins.semiBold(size: 17.scale))
            .lineHeight(22.scale)
        
        let view = UIButton()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 28.scale
        view.setAttributedTitle("OK".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBottomLineLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 65, green: 65, blue: 65))
            .font(Fonts.Poppins.semiBold(size: 15.scale))
            .lineHeight(20.scale)
            .letterSpacing(-0.4.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.TrackTemperaturePurpose.BottomLine".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
