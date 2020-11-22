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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        NSLayoutConstraint.activate([
            journalReportButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            journalReportButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            journalReportButton.heightAnchor.constraint(equalToConstant: 72.scale),
            journalReportButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -32.scale : -16.scale)
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
}
