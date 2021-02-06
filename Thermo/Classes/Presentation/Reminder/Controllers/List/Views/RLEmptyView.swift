//
//  RLEmptyView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 04.02.2021.
//

import UIKit

final class RLEmptyView: UIView {
    lazy var label = makeLabel()
    lazy var button = makeButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension RLEmptyView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            label.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 175.scale),
            button.heightAnchor.constraint(equalToConstant: 52.scale),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20.scale),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension RLEmptyView {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.black.withAlphaComponent(0.4))
            .font(Fonts.Poppins.regular(size: 18.scale))
            .lineHeight(24.scale)
            .letterSpacing(0.2.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Reminder.List.EmptyText".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .font(Fonts.Poppins.semiBold(size: 18.scale))
            .textColor(UIColor.white)
        
        let view = UIButton()
        view.layer.cornerRadius = 26.scale
        view.backgroundColor = UIColor(integralRed: 148, green: 165, blue: 225)
        view.setAttributedTitle("Reminder.List.EmptyAdd".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
