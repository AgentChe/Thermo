//
//  OnboardingSlideView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 03.02.2021.
//

import UIKit

final class OnboardingSlideView: UIView {
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeTitleLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension OnboardingSlideView {
    func setup(model: OnboardingSlide) {
        imageView.image = UIImage(named: model.imageName)
        titleLabel.text = model.title
    }
}

// MARK: Make constraints
private extension OnboardingSlideView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 244.scale),
            imageView.heightAnchor.constraint(equalToConstant: 234.scale),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 212.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OnboardingSlideView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.textColor = UIColor(integralRed: 83, green: 83, blue: 83)
        view.font = Fonts.Poppins.semiBold(size: 25.scale)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

