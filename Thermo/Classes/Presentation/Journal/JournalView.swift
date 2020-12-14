//
//  JournalView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import UIKit

final class JournalView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var imageView = makeImageView()
    lazy var tableView = makeTableView()
    lazy var journalReportButton = makeJournalReportButton()
    lazy var desclaimerView = makeDesclaimerView()
    lazy var emptyLabel = makeEmptyLabel()
    
    private var journalReportButtonBottomConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension JournalView {
    func desclaimerView(hidden: Bool) {
        desclaimerView.isHidden = hidden
        
        let bottom = hidden ? bottomAnchor : desclaimerView.topAnchor
        
        journalReportButtonBottomConstraint.isActive = false
        
        journalReportButtonBottomConstraint = journalReportButton.bottomAnchor.constraint(equalTo: bottom, constant: -18.scale)
        journalReportButtonBottomConstraint.isActive = true
        
        journalReportButton.layoutIfNeeded()
    }
}

// MARK: Make constraints
private extension JournalView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 52.scale),
            imageView.heightAnchor.constraint(equalToConstant: 52.scale),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 90.scale : 55.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            titleLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: journalReportButton.topAnchor, constant: -6.scale),
            tableView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40.scale)
        ])
        
        journalReportButtonBottomConstraint = journalReportButton.bottomAnchor.constraint(equalTo: desclaimerView.topAnchor, constant: -18.scale)
        NSLayoutConstraint.activate([
            journalReportButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            journalReportButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            journalReportButton.heightAnchor.constraint(equalToConstant: 72.scale),
            journalReportButtonBottomConstraint
        ])
        
        NSLayoutConstraint.activate([
            desclaimerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            desclaimerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            desclaimerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18.scale)
        ])
        
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension JournalView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 50, green: 50, blue: 52))
            .font(Fonts.Poppins.bold(size: 28.scale))
            .lineHeight(34.scale)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Journal.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 26.scale
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> JournalTableView {
        let view = JournalTableView()
        view.separatorStyle = .none
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeJournalReportButton() -> JournalReportButton {
        let view = JournalReportButton()
        view.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        view.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.gradientLayer.colors = [
            UIColor(integralRed: 255, green: 165, blue: 2).cgColor,
            UIColor(integralRed: 255, green: 99, blue: 72).cgColor
        ]
        view.layer.cornerRadius = 36.scale
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
    
    func makeEmptyLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.black.withAlphaComponent(0.4))
            .font(Fonts.Poppins.regular(size: 18.scale))
            .lineHeight(22.scale)
            .letterSpacing(0.2.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Journal.Empty".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
