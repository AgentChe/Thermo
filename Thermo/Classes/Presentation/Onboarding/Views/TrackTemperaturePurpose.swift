//
//  TrackTemperaturePurpose.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 26.10.2020.
//

import UIKit

final class TrackTemperaturePurpose: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var cell1 = makeCell(image: "Onboarding.TrackTemperaturePurpose.Cell1Icon", text: "Onboarding.TrackTemperaturePurpose.Cell1")
    lazy var cell2 = makeCell(image: "Onboarding.TrackTemperaturePurpose.Cell2Icon", text: "Onboarding.TrackTemperaturePurpose.Cell2")
    lazy var cell3 = makeCell(image: "Onboarding.TrackTemperaturePurpose.Cell3Icon", text: "Onboarding.TrackTemperaturePurpose.Cell3")
    lazy var cell4 = makeCell(image: "Onboarding.TrackTemperaturePurpose.Cell4Icon", text: "Onboarding.TrackTemperaturePurpose.Cell4")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension TrackTemperaturePurpose {
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
        
        NSLayoutConstraint.activate([
            cell4.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48.scale),
            cell4.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48.scale),
            cell4.topAnchor.constraint(equalTo: cell3.bottomAnchor, constant: 24.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TrackTemperaturePurpose {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.OpenSans.bold(size: 34.scale))
            .lineHeight(37.scale)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.TrackTemperaturePurpose.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell(image: String, text: String) -> OnbrdIInfoCell {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 50, green: 50, blue: 52))
            .font(Fonts.Poppins.semiBold(size: 15.scale))
            .lineHeight(20.scale)
            .letterSpacing(-0.4.scale)
        
        let view = OnbrdIInfoCell()
        view.imageView.image = UIImage(named: image)
        view.label.attributedText = text.localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
