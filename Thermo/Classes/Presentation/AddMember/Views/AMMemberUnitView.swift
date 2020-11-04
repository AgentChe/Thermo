//
//  AMMemberUnitView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.10.2020.
//

import UIKit

final class AMMemberUnitView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var meUnitCell = makeCell(title: "AddMember.MemberUnit.Me")
    lazy var childUnitCell = makeCell(title: "AddMember.MemberUnit.Child")
    lazy var parentUnitCell = makeCell(title: "AddMember.MemberUnit.Parent")
    lazy var otherUnitCell = makeCell(title: "AddMember.MemberUnit.Other")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension AMMemberUnitView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 120.scale : 60.scale)
        ])
        
        NSLayoutConstraint.activate([
            meUnitCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            meUnitCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            meUnitCell.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25.scale)
        ])
        
        NSLayoutConstraint.activate([
            childUnitCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            childUnitCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            childUnitCell.topAnchor.constraint(equalTo: meUnitCell.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            parentUnitCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            parentUnitCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            parentUnitCell.topAnchor.constraint(equalTo: childUnitCell.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            otherUnitCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            otherUnitCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            otherUnitCell.topAnchor.constraint(equalTo: parentUnitCell.bottomAnchor, constant: 16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension AMMemberUnitView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.OpenSans.bold(size: 34.scale))
            .lineHeight(37.scale)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "AddMember.MemberUnit.Title".localized.attributed(with: attrs)
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
