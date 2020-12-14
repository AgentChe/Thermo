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
            leftImageView.widthAnchor.constraint(equalToConstant: 31.scale),
            leftImageView.heightAnchor.constraint(equalToConstant: 31.scale),
            leftImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 44.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48.scale)
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
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
