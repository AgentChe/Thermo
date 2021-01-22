//
//  EMPlaceholderView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 22.01.2021.
//

import UIKit

final class EMPlaceholderView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var imageView = makeImageView()
    lazy var bottomLabel = makeBottomLabel()
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
private extension EMPlaceholderView {
    func initialize() {
        backgroundColor = UIColor.white
    }
}

// MARK: Make constraints
private extension EMPlaceholderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -20.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 313.scale),
            imageView.heightAnchor.constraint(equalToConstant: 332.scale),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 83.scale),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 202.scale)
        ])
        
        NSLayoutConstraint.activate([
            bottomLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            bottomLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            bottomLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 50.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 98.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -98.scale),
            button.heightAnchor.constraint(equalToConstant: 56.scale),
            button.topAnchor.constraint(equalTo: bottomLabel.bottomAnchor, constant: 25.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension EMPlaceholderView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 2, green: 13, blue: 14))
            .font(Fonts.Poppins.bold(size: 34.scale))
            .lineHeight(41.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "EMLogger.Placeholder.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "EMLogger.Placeholder")
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBottomLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 2, green: 13, blue: 14))
            .font(Fonts.Poppins.semiBold(size: 17.scale))
            .lineHeight(22.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "EMLogger.Placeholder.BottomText".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> GradientButton {
        let attrs = TextAttributes()
            .font(Fonts.Poppins.semiBold(size: 17.scale))
            .textColor(UIColor.white)
            .textAlignment(.center)
        
        let view = GradientButton()
        view.gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        view.gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        view.gradientLayer.colors = [
            UIColor(integralRed: 255, green: 165, blue: 2).cgColor,
            UIColor(integralRed: 255, green: 99, blue: 72).cgColor
        ]
        view.layer.cornerRadius = 28.scale
        view.setAttributedTitle("EMLogger.Placeholder.Button".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
