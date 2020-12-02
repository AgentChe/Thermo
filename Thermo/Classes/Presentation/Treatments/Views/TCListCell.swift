//
//  TCListCell.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 02.12.2020.
//

import UIKit

final class TCListCell: UITableViewCell {
    lazy var containerView = makeBackgroundView()
    lazy var titleLabel = makeLabel()
    lazy var statusLabel = makeLabel()
    lazy var scoreLabel = makeLabel()
    lazy var scoreView = makeScoreView()
    lazy var arrowView = makeArrowView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension TCListCell {
    func setup(condition: TreatmentCondition) {
        titleLabel.attributedText = condition.name
            .attributed(with: TextAttributes()
                .textColor(UIColor(integralRed: 21, green: 21, blue: 34))
                .font(Fonts.Poppins.semiBold(size: 15.scale))
                .lineHeight(20.scale))
        
        statusLabel.attributedText = condition.status
            .attributed(with: TextAttributes()
                .textColor(UIColor(integralRed: 153, green: 153, blue: 153))
                .font(Fonts.Poppins.regular(size: 11.scale))
                .lineHeight(13.scale))
        
        scoreLabel.attributedText = String(format: "%i %", Int(condition.score))
            .attributed(with: TextAttributes()
                .textColor(UIColor(integralRed: 153, green: 153, blue: 153))
                .font(Fonts.Poppins.regular(size: 11.scale))
                .lineHeight(13.scale))
        
        scoreView.score = CGFloat(condition.score)
    }
}

// MARK: Private
private extension TCListCell {
    func configure() {
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}
// MARK: Make constraints
private extension TCListCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 85.scale),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -25.scale),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 21.scale)
        ])
        
        NSLayoutConstraint.activate([
            statusLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 85.scale),
            statusLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -25.scale),
            statusLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 46.scale)
        ])
        
        NSLayoutConstraint.activate([
            scoreView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20.scale),
            scoreView.widthAnchor.constraint(equalToConstant: 50.scale),
            scoreView.heightAnchor.constraint(equalToConstant: 50.scale),
            scoreView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            scoreLabel.centerXAnchor.constraint(equalTo: scoreView.centerXAnchor),
            scoreLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            arrowView.widthAnchor.constraint(equalToConstant: 9.scale),
            arrowView.heightAnchor.constraint(equalToConstant: 16.scale),
            arrowView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.scale),
            arrowView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TCListCell {
    func makeBackgroundView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
    
    func makeScoreView() -> TCScoreView {
        let view = TCScoreView(size: 50.scale, progressColor: UIColor(integralRed: 80, green: 179, blue: 190))
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
    
    func makeArrowView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Treatments.Arrow")
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
}
