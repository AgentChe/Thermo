//
//  TrackTemperatureImportant.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.10.2020.
//

import UIKit

final class TrackTemperatureImportant: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var cell1 = makeCell(image: "Onboarding.TrackTemperatureImportant.Cell1",
                              part1: "Onboarding.TrackTemperatureImportant.Cell1Part1",
                              part2: "Onboarding.TrackTemperatureImportant.Cell1Part2")
    lazy var cell2 = makeCell(image: "Onboarding.TrackTemperatureImportant.Cell2",
                              part1: "Onboarding.TrackTemperatureImportant.Cell2Part1",
                              part2: "Onboarding.TrackTemperatureImportant.Cell2Part2")
    lazy var cell3 = makeCell(image: "Onboarding.TrackTemperatureImportant.Cell3",
                              part1: "Onboarding.TrackTemperatureImportant.Cell3Part1",
                              part2: "Onboarding.TrackTemperatureImportant.Cell3Part2")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension TrackTemperatureImportant {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 120.scale : 60.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48.scale),
            cell1.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48.scale),
            cell1.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 36.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48.scale),
            cell2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48.scale),
            cell2.topAnchor.constraint(equalTo: cell1.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell3.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48.scale),
            cell3.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48.scale),
            cell3.topAnchor.constraint(equalTo: cell2.bottomAnchor, constant: 24.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TrackTemperatureImportant {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.OpenSans.bold(size: 34.scale))
            .lineHeight(37.scale)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.TrackTemperatureImportant.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell(image: String, part1: String, part2: String) -> OnbrdIInfoCell {
        let attrs = TextAttributes()
            .lineHeight(20.scale)
            .letterSpacing(-0.4.scale)
        
        let part1Attrs = attrs
            .textColor(UIColor.black)
            .font(Fonts.Poppins.bold(size: 15.scale))
        
        let part2Attrs = attrs
            .textColor(UIColor(integralRed: 50, green: 50, blue: 52))
            .font(Fonts.Poppins.semiBold(size: 15.scale))
        
        let text = NSMutableAttributedString()
        text.append(part1.localized.attributed(with: part1Attrs))
        text.append(part2.localized.attributed(with: part2Attrs))
        
        let view = OnbrdIInfoCell()
        view.imageView.image = UIImage(named: image)
        view.label.attributedText = text
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
