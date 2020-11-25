//
//  AMGenderView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 20.11.2020.
//

import UIKit

final class AMGenderView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var maleCell = makeCell(title: "AddMember.Gender.Male")
    lazy var femaleCell = makeCell(title: "AddMember.Gender.Female")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension AMGenderView {
    func setup(with selectedUnit: AMMemberUnit) {
        let attrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.OpenSans.bold(size: 34.scale))
            .lineHeight(37.scale)
        
        let title: String
        switch selectedUnit {
        case .me:
            title = "AddMember.Gender.TitleForMeUnit".localized
        case .child, .other, .parent:
            title = "AddMember.Gender.TitleForNotMeUnit".localized
        }
        
        titleLabel.attributedText = title.localized.attributed(with: attrs)
    }
}

// MARK: Make constraints
private extension AMGenderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 120.scale : 60.scale)
        ])
        
        NSLayoutConstraint.activate([
            maleCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            maleCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            maleCell.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 45.scale)
        ])
        
        NSLayoutConstraint.activate([
            femaleCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            femaleCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            femaleCell.topAnchor.constraint(equalTo: maleCell.bottomAnchor, constant: 16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension AMGenderView {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell(title: String) -> AMCheckedCell {
        let attrs = TextAttributes()
            .font(Fonts.Poppins.semiBold(size: 17.scale))
            .textColor(UIColor(integralRed: 74, green: 71, blue: 73))
            .lineHeight(22.scale)
            .letterSpacing(-0.5.scale)
        
        let view = AMCheckedCell()
        view.label.attributedText = title.localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
