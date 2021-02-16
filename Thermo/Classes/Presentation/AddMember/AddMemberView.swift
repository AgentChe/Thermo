//
//  AddMemberView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.10.2020.
//

import UIKit

final class AddMemberView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var fahrenheitCell = makeFahrenheitCell()
    lazy var celsiusCell = makeCelsiusCell()
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
private extension AddMemberView {
    func initialize() {
        backgroundColor = UIColor.white
    }
}

// MARK: Make constraints
private extension AddMemberView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 120.scale : 60.scale),
        ])
        
        NSLayoutConstraint.activate([
            fahrenheitCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            fahrenheitCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            fahrenheitCell.heightAnchor.constraint(equalToConstant: 52.scale),
            fahrenheitCell.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            celsiusCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            celsiusCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            celsiusCell.heightAnchor.constraint(equalToConstant: 52.scale),
            celsiusCell.topAnchor.constraint(equalTo: fahrenheitCell.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 180.scale),
            button.heightAnchor.constraint(equalToConstant: 56.scale),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -50.scale : -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension AddMemberView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.Poppins.bold(size: 34.scale))
            .lineHeight(41.scale)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "AddMember.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeFahrenheitCell() -> AMCheckedCell {
        let attrs = TextAttributes()
            .font(Fonts.Poppins.regular(size: 17.scale))
            .lineHeight(22.scale)
            .letterSpacing(-0.5.scale)
        
        let view = AMCheckedCell()
        view.isSelected = false
        view.label.attributedText = "Fahrenheit".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCelsiusCell() -> AMCheckedCell {
        let attrs = TextAttributes()
            .font(Fonts.Poppins.regular(size: 17.scale))
            .lineHeight(22.scale)
            .letterSpacing(-0.5.scale)
        
        let view = AMCheckedCell()
        view.isSelected = false
        view.label.attributedText = "Celsius".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .font(Fonts.Poppins.semiBold(size: 17.scale))
            .textColor(UIColor.white)
            .lineHeight(22.scale)
        
        let view = UIButton()
        view.layer.cornerRadius = 28.scale
        view.backgroundColor = UIColor(integralRed: 148, green: 165, blue: 225)
        view.setAttributedTitle("AddMember.Button".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

