//
//  OverallFeelingView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import UIKit

final class OverallFeelingView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var goodItem = makeItem(emoji: "😀", name: "TemperatureLogger.Feeling.Health.Good".localized, checked: true)
    lazy var sickItem = makeItem(emoji: "🤒", name: "TemperatureLogger.Feeling.Health.Sick".localized, checked: false)
    lazy var badItem = makeItem(emoji: "😞", name: "TemperatureLogger.Feeling.Health.Bad".localized, checked: false)
    lazy var recoveredItem = makeItem(emoji: "😇", name: "TemperatureLogger.Feeling.Health.Recovered".localized, checked: false)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension OverallFeelingView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            goodItem.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            goodItem.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14.scale),
            goodItem.bottomAnchor.constraint(equalTo: bottomAnchor),
            goodItem.heightAnchor.constraint(equalToConstant: 92.scale),
            goodItem.widthAnchor.constraint(equalToConstant: 70.scale)
        ])
        
        NSLayoutConstraint.activate([
            sickItem.leadingAnchor.constraint(equalTo: goodItem.trailingAnchor, constant: 18.scale),
            sickItem.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14.scale),
            sickItem.bottomAnchor.constraint(equalTo: bottomAnchor),
            sickItem.heightAnchor.constraint(equalToConstant: 92.scale),
            sickItem.widthAnchor.constraint(equalToConstant: 70.scale)
        ])
        
        NSLayoutConstraint.activate([
            badItem.leadingAnchor.constraint(equalTo: sickItem.trailingAnchor, constant: 18.scale),
            badItem.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14.scale),
            badItem.bottomAnchor.constraint(equalTo: bottomAnchor),
            badItem.heightAnchor.constraint(equalToConstant: 92.scale),
            badItem.widthAnchor.constraint(equalToConstant: 70.scale)
        ])
        
        NSLayoutConstraint.activate([
            recoveredItem.leadingAnchor.constraint(equalTo: badItem.trailingAnchor, constant: 18.scale),
            recoveredItem.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14.scale),
            recoveredItem.bottomAnchor.constraint(equalTo: bottomAnchor),
            recoveredItem.heightAnchor.constraint(equalToConstant: 92.scale),
            recoveredItem.widthAnchor.constraint(equalToConstant: 70.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OverallFeelingView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.Poppins.bold(size: 14.scale))
            .textAlignment(.left)
            .lineHeight(21.scale)
            .letterSpacing(0.5.scale)
    
        let view = UILabel()
        view.attributedText = "TemperatureLogger.Feeling.Health.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeItem(emoji: String, name: String, checked: Bool) -> OverallFeelingItemView {
        let view = OverallFeelingItemView()
        view.backgroundColor = UIColor.clear
        view.setup(emoji: emoji, name: name, checked: checked)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
