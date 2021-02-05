//
//  RLTableCell.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 04.02.2021.
//

import UIKit

final class RLTableCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var timeLabel = makeLabel()
    lazy var weekdayLabel = makeLabel()
    lazy var switchControl = makeSwitch()
    
    private var switched: ((Bool) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension RLTableCell {
    func setup(element: RLTableElement) {
        switched = element.switched
        
        switchControl.isOn = element.reminder.checked
        
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "HH:mm"
        
        let timeAttrs = TextAttributes()
            .textColor(UIColor(integralRed: 50, green: 50, blue: 52))
            .font(Fonts.Poppins.regular(size: 22.scale))
            .lineHeight(34.scale)
        timeLabel.attributedText = formatter.string(from: element.reminder.time).attributed(with: timeAttrs)
        
        let weekdayAttrs = TextAttributes()
            .textColor(UIColor(integralRed: 60, green: 60, blue: 67, alpha: 0.3))
            .font(Fonts.Poppins.regular(size: 10.scale))
            .lineHeight(12.scale)
        weekdayLabel.attributedText = WeekdayLocalizable.localize(weekday: element.reminder.weekday).attributed(with: weekdayAttrs)
    }
}

// MARK: Private
private extension RLTableCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
    
    @objc
    func didSwitch() {
        switched?(switchControl.isOn)
    }
}

// MARK: Make constraints
private extension RLTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -26.scale)
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24.scale),
            timeLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -24.scale),
            timeLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 23.scale)
        ])
        
        NSLayoutConstraint.activate([
            weekdayLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24.scale),
            weekdayLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -24.scale),
            weekdayLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4.scale)
        ])
        
        NSLayoutConstraint.activate([
            switchControl.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -35.scale),
            switchControl.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension RLTableCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 20.scale
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeSwitch() -> UISwitch {
        let view = UISwitch()
        view.addTarget(self, action: #selector(didSwitch), for: .valueChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
