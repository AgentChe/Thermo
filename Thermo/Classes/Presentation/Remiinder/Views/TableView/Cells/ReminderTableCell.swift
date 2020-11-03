//
//  ReminderTableCell.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 01.11.2020.
//

import UIKit
import RxCocoa

final class ReminderTableCell: UITableViewCell {
    lazy var label = makeLabel()
    lazy var switchControl = makeSwitch()
    
    private var switched: ((Bool) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension ReminderTableCell {
    func setup(element: ReminderTableSwitchElement) {
        label.attributedText = element.text
            .attributed(with: TextAttributes()
                            .textColor(UIColor(integralRed: 50, green: 50, blue: 52))
                            .font(Fonts.OpenSans.regular(size: 20.scale))
                            .lineHeight(25.scale))
        
        switchControl.isOn = element.isOn
        
        switched = element.switched
    }
}

// MARK: Private
private extension ReminderTableCell {
    func configure() {
        contentView.backgroundColor = .clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = .clear
        selectedBackgroundView = selectedView
    }
    
    @objc
    func didSwitch() {
        switched?(switchControl.isOn)
    }
}

// MARK: Make constraints
private extension ReminderTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24.scale),
            label.trailingAnchor.constraint(equalTo: switchControl.leadingAnchor, constant: -16.scale),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.scale),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.scale)
        ])
        
        NSLayoutConstraint.activate([
            switchControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24.scale),
            switchControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ReminderTableCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false 
        contentView.addSubview(view)
        return view
    }
    
    func makeSwitch() -> UISwitch {
        let view = UISwitch()
        view.addTarget(self, action: #selector(didSwitch), for: .valueChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
