//
//  TCDetailView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 02.12.2020.
//

import UIKit

final class TCDetailView: GradientView {
    lazy var titleLabel = makeLabel()
    lazy var desclaimerView = makeDesclaimerView()
    lazy var scoreView = makeScoreView()
    lazy var scoreLabel = makeLabel()
    lazy var textView = makeTextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 112.scale : 60.scale)
        ])
        
        NSLayoutConstraint.activate([
            desclaimerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            desclaimerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            desclaimerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 30.scale : 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            scoreView.centerXAnchor.constraint(equalTo: centerXAnchor),
            scoreView.widthAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 139.scale : 90.scale),
            scoreView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 139.scale : 90.scale),
            scoreView.topAnchor.constraint(equalTo: desclaimerView.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 31.scale : 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            scoreLabel.centerXAnchor.constraint(equalTo: scoreView.centerXAnchor),
            scoreLabel.centerYAnchor.constraint(equalTo: scoreView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            textView.topAnchor.constraint(equalTo: scoreView.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 31.scale : 16.scale),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor)
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
    
    func makeDesclaimerView() -> TCDisclaimerView {
        let view = TCDisclaimerView()
        view.backgroundColor = UIColor(integralRed: 252, green: 242, blue: 250)
        view.layer.cornerRadius = 4.scale
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = UIColor(integralRed: 241, green: 223, blue: 238).cgColor
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
}
