//
//  TCDisclaimerView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 12.12.2020.
//

import UIKit

final class TCDisclaimerView: UIView {
    lazy var label = makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        addTapAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension TCDisclaimerView {
    func addTapAction() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(gesture)
    }
    
    @objc
    func tapped() {
        let url = URL(string: "https://thermo.korrekted.com/disclaimer.html")
        
        guard let openUrl = url else {
            return
        }
        
        UIApplication.shared.open(openUrl, options: [:])
    }
}

// MARK: Make constraints
private extension TCDisclaimerView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 8.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TCDisclaimerView {
    func makeLabel() -> UILabel {
        let part1 = "Treatments.Disclaimer.DISCLAIMER".localized
            .attributed(with: TextAttributes()
                            .textColor(UIColor(integralRed: 148, green: 54, blue: 112))
                            .font(Fonts.Poppins.bold(size: 12.scale))
                            .lineHeight(16.scale))
        
        let part2 = "Treatments.Disclaimer.Text".localized
            .attributed(with: TextAttributes()
                            .textColor(UIColor(integralRed: 148, green: 54, blue: 112))
                            .font(Fonts.Poppins.regular(size: 12.scale))
                            .lineHeight(16.scale))
        
        let part3 = "Treatments.Disclaimer.LearnMore".localized
            .attributed(with: TextAttributes()
                            .textColor(UIColor(integralRed: 148, green: 54, blue: 112))
                            .font(Fonts.Poppins.regular(size: 12.scale))
                            .lineHeight(16.scale)
                            .underlineStyle(.single)
                            .underlineColor(UIColor(integralRed: 148, green: 54, blue: 112)))
        
        let string = NSMutableAttributedString()
        string.append(part1)
        string.append(part2)
        string.append(part3)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = string
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
