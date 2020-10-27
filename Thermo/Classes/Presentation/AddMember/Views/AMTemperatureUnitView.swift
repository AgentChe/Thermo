//
//  AMTemperatureUnitView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.10.2020.
//

import UIKit

final class AMTemperatureUnitView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var fahrenheitCell = makeCell(title: "Fahrenheit")
    lazy var celsiusCell = makeCell(title: "Celsius")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension AMTemperatureUnitView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 120.scale)
        ])
        
        NSLayoutConstraint.activate([
            fahrenheitCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            fahrenheitCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            fahrenheitCell.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25.scale)
        ])
        
        NSLayoutConstraint.activate([
            celsiusCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            celsiusCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            celsiusCell.topAnchor.constraint(equalTo: fahrenheitCell.bottomAnchor, constant: 16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension AMTemperatureUnitView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.OpenSans.bold(size: 34.scale))
            .lineHeight(37.scale)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "AddMember.TemperatureUnit.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell(title: String) -> AMCheckedCell {
        let attrs = TextAttributes()
            .font(Fonts.Poppins.semiBold(size: 17.scale))
            .textColor(UIColor(integralRed: 74, green: 71, blue: 73))
            .lineHeight(22.scale)
            .letterSpacing(-0.5.scale)
        
        let view = AMCheckedCell()
        view.label.attributedText = title.localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

