//
//  JournalReportButton.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 22.11.2020.
//

import UIKit

final class JournalReportButton: GradientView {
    lazy var leftImageView = makeLeftImageView()
    lazy var titleLabel = makeTitleLabel()
    lazy var buttonView = makeButtonView()
    lazy var buttonEmojiView = makeButtonLeftEmoji()
    lazy var buttonTitleLabel = makeButtonTitleLabel()
    lazy var buttonArrowImageView = makeButtonArrowImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension JournalReportButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            leftImageView.widthAnchor.constraint(equalToConstant: 24.scale),
            leftImageView.heightAnchor.constraint(equalToConstant: 24.scale),
            leftImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 21.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            buttonView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -21.scale),
            buttonView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            buttonEmojiView.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: 16.scale),
            buttonEmojiView.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            buttonTitleLabel.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: 39.scale),
            buttonTitleLabel.trailingAnchor.constraint(equalTo: buttonArrowImageView.leadingAnchor, constant: -13.scale),
            buttonTitleLabel.topAnchor.constraint(equalTo: buttonView.topAnchor, constant: 6.scale),
            buttonTitleLabel.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor, constant: -6.scale)
        ])
        
        NSLayoutConstraint.activate([
            buttonArrowImageView.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor, constant: -16.scale),
            buttonArrowImageView.widthAnchor.constraint(equalToConstant: 6.scale),
            buttonArrowImageView.heightAnchor.constraint(equalToConstant: 12.scale),
            buttonArrowImageView.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension JournalReportButton {
    func makeLeftImageView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Journal.Report.LeftImage")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.Poppins.semiBold(size: 14.scale))
            .lineHeight(20.scale)
            .letterSpacing(0.2.scale)
        
        let view = UILabel()
        view.attributedText = "Journal.Report.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButtonView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 16.scale
        view.layer.borderWidth = 2.scale
        view.layer.borderColor = UIColor.white.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButtonLeftEmoji() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.Poppins.regular(size: 11.scale))
            .lineHeight(15.71.scale)
            .letterSpacing(0.16.scale)
        
        let view = UILabel()
        view.attributedText = "Journal.Report.ButtonImage".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        buttonView.addSubview(view)
        return view
    }
    
    func makeButtonTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.Poppins.regular(size: 14.scale))
            .lineHeight(20.scale)
            .letterSpacing(0.2.scale)
        
        let view = UILabel()
        view.attributedText = "Journal.Report.ButtonTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        buttonView.addSubview(view)
        return view
    }
    
    func makeButtonArrowImageView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Journal.Report.Arrow")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        buttonView.addSubview(view)
        return view
    }
}
