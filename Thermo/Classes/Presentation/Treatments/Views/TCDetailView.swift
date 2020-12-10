//
//  TCDetailView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 02.12.2020.
//

import UIKit

final class TCDetailView: GradientView {
    lazy var titleLabel = makeLabel()
    lazy var scoreView = makeScoreView()
    lazy var scoreLabel = makeLabel()
    lazy var textView = makeTextView()
    lazy var button = makeButton()
    
    private let hideNextButton: Bool
    
    init(hideNextButton: Bool) {
        self.hideNextButton = hideNextButton
        
        super.init(frame: .zero)
        
        makeConstraints()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension TCDetailView {
    func configure() {
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        gradientLayer.colors = [
            UIColor(integralRed: 211, green: 106, blue: 143).cgColor,
            UIColor(integralRed: 174, green: 108, blue: 199).cgColor,
        ]
    }
}

// MARK: Make constraints
private extension TCDetailView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.bottomAnchor.constraint(equalTo: scoreView.topAnchor, constant: ScreenSize.isIphoneXFamily ? -30.scale : -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            scoreView.centerXAnchor.constraint(equalTo: centerXAnchor),
            scoreView.widthAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 139.scale : 90.scale),
            scoreView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 139.scale : 90.scale),
            scoreView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 193.scale : 160.scale)
        ])
        
        NSLayoutConstraint.activate([
            scoreLabel.centerXAnchor.constraint(equalTo: scoreView.centerXAnchor),
            scoreLabel.centerYAnchor.constraint(equalTo: scoreView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            textView.topAnchor.constraint(equalTo: scoreView.bottomAnchor, constant: 37.scale),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: hideNextButton ? -29.scale : -101.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 34.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -34.scale),
            button.heightAnchor.constraint(equalToConstant: 56.scale),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -29.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TCDetailView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeScoreView() -> TCScoreView {
        let view = TCScoreView(size: ScreenSize.isIphoneXFamily ? 139.scale : 90.scale, progressColor: UIColor(integralRed: 130, green: 106, blue: 249))
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextView() -> UITextView {
        let view = UITextView()
        view.isEditable = false 
        view.showsVerticalScrollIndicator = true
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.Poppins.semiBold(size: 17.scale))
            .lineHeight(22.scale)
            .textAlignment(.center)
        
        let view = UIButton()
        view.isHidden = hideNextButton
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 28.scale
        view.setAttributedTitle("Treatments.Details.Button".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
