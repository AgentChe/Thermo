//
//  FeelingSelectionView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 05.02.2021.
//

import UIKit

final class FeelingSelectionView: UIView {
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeTitleLabel()
    lazy var goodView = makeEmojiView(text: "Feeling.Good", image: "Feeling.Good")
    lazy var sickView = makeEmojiView(text: "Feeling.Sick", image: "Feeling.Sick")
    lazy var badView = makeEmojiView(text: "Feeling.Bad", image: "Feeling.Bad")
    lazy var recoveredView = makeEmojiView(text: "Feeling.Recovered", image: "Feeling.Recovered")
    lazy var symptomsButton = makeSymptomsButton()
    lazy var medicationsButton = makeMedicationsButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension FeelingSelectionView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 57.scale),
            imageView.heightAnchor.constraint(equalToConstant: 57.scale),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 25.scale),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 97.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            goodView.widthAnchor.constraint(equalToConstant: 61.scale),
            goodView.heightAnchor.constraint(equalToConstant: 83.scale),
            goodView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            goodView.topAnchor.constraint(equalTo: topAnchor, constant: 97.scale)
        ])
        
        NSLayoutConstraint.activate([
            sickView.widthAnchor.constraint(equalToConstant: 61.scale),
            sickView.heightAnchor.constraint(equalToConstant: 83.scale),
            sickView.leadingAnchor.constraint(equalTo: goodView.trailingAnchor, constant: 16.scale),
            sickView.topAnchor.constraint(equalTo: topAnchor, constant: 97.scale)
        ])
        
        NSLayoutConstraint.activate([
            badView.widthAnchor.constraint(equalToConstant: 61.scale),
            badView.heightAnchor.constraint(equalToConstant: 83.scale),
            badView.leadingAnchor.constraint(equalTo: sickView.trailingAnchor, constant: 16.scale),
            badView.topAnchor.constraint(equalTo: topAnchor, constant: 97.scale)
        ])
        
        NSLayoutConstraint.activate([
            recoveredView.widthAnchor.constraint(equalToConstant: 61.scale),
            recoveredView.heightAnchor.constraint(equalToConstant: 83.scale),
            recoveredView.leadingAnchor.constraint(equalTo: badView.trailingAnchor, constant: 16.scale),
            recoveredView.topAnchor.constraint(equalTo: topAnchor, constant: 97.scale)
        ])
        
        NSLayoutConstraint.activate([
            symptomsButton.widthAnchor.constraint(equalToConstant: 133.scale),
            symptomsButton.heightAnchor.constraint(equalToConstant: 29.scale),
            symptomsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26.scale),
            symptomsButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25.scale)
        ])
        
        NSLayoutConstraint.activate([
            medicationsButton.widthAnchor.constraint(equalToConstant: 133.scale),
            medicationsButton.heightAnchor.constraint(equalToConstant: 29.scale),
            medicationsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26.scale),
            medicationsButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension FeelingSelectionView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Feeling.Status")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 83, green: 83, blue: 83))
            .font(Fonts.Poppins.semiBold(size: 20.scale))
            .lineHeight(25.scale)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Feeling.TodayIFeeling".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeEmojiView(text: String, image: String) -> FeelingEmojiView {
        let view = FeelingEmojiView()
        view.label.text = text.localized
        view.imageView.image = UIImage(named: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSymptomsButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 83, green: 83, blue: 83))
            .font(Fonts.Poppins.bold(size: 12.scale))
            .lineHeight(18.scale)
            .letterSpacing(0.5.scale)
        
        let view = UIButton()
        view.backgroundColor = UIColor(integralRed: 246, green: 246, blue: 246)
        view.layer.cornerRadius = 18.scale
        view.setAttributedTitle("Feeling.Symptoms".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeMedicationsButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 83, green: 83, blue: 83))
            .font(Fonts.Poppins.bold(size: 12.scale))
            .lineHeight(18.scale)
            .letterSpacing(0.5.scale)
        
        let view = UIButton()
        view.backgroundColor = UIColor(integralRed: 246, green: 246, blue: 246)
        view.layer.cornerRadius = 18.scale
        view.setAttributedTitle("Feeling.Medications".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
