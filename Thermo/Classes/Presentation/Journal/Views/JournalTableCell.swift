//
//  JournalTableCell.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import UIKit

final class JournalTableCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var dateTimeLabel = makeDateTimeLabel()
    lazy var temperatureLabel = makeTemperatureLabel()
    lazy var overallFeelingImageView = makeOverallFeelingImageView()
    
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
extension JournalTableCell {
    func setup(element: JournalTableElement) {
        dateTimeLabel.attributedText = dateTime(from: element)
        temperatureLabel.attributedText = temperature(from: element)
        overallFeelingImageView.image = overallFeeling(from: element)
    }
    
    func dateTime(from element: JournalTableElement) -> NSAttributedString {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd MMM,  "
        let date = dateFormatter
            .string(from: element.date)
            .attributed(with: TextAttributes()
                            .textColor(UIColor(integralRed: 50, green: 50, blue: 52))
                            .font(Fonts.OpenSans.regular(size: 17.scale))
                            .lineHeight(22.scale)
                            .letterSpacing(-0.4.scale)
                            .textAlignment(.center))
        
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter
            .string(from: element.date)
            .attributed(with: TextAttributes()
                            .textColor(UIColor(integralRed: 50, green: 50, blue: 52, alpha: 0.5))
                            .font(Fonts.Poppins.semiBold(size: 17.scale))
                            .lineHeight(27.scale)
                            .letterSpacing(-0.4.scale)
                            .textAlignment(.center))
        
        let dateTime = NSMutableAttributedString()
        dateTime.append(date)
        dateTime.append(time)
        
        return dateTime
    }
    
    func temperature(from element: JournalTableElement) -> NSAttributedString {
        let unit: String
        switch element.unit {
        case .fahrenheit:
            unit = "Fahrenheit".localized
        case .celsius:
            unit = "Celsius".localized
        }
        
        let color: UIColor
        if element.temperature > 37.1 {
            color = UIColor(integralRed: 255, green: 126, blue: 103)
        } else if element.temperature < 36.0 {
            color = UIColor(integralRed: 108, green: 22, blue: 245)
        } else {
            color = UIColor(integralRed: 50, green: 50, blue: 52)
        }
        
        return String(format: "%.1f %@", element.temperature, unit)
            .attributed(with: TextAttributes()
                            .textColor(color)
                            .font(Fonts.OpenSans.regular(size: 20.scale))
                            .lineHeight(25.scale))
    }
    
    func overallFeeling(from element: JournalTableElement) -> UIImage? {
        switch element.overallFeeiling {
        case .bad:
            return UIImage(named: "TemperatureLogger.Feeiling.Bad")
        case .meh:
            return UIImage(named: "TemperatureLogger.Feeiling.Meh")
        case .good:
            return UIImage(named: "TemperatureLogger.Feeiling.Good")
        }
    }
}

// MARK: Private
private extension JournalTableCell {
    func configure() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = .clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension JournalTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.heightAnchor.constraint(equalToConstant: 50.scale),
            container.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dateTimeLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8.scale),
            dateTimeLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            temperatureLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -65.scale),
            temperatureLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            overallFeelingImageView.widthAnchor.constraint(equalToConstant: 34.scale),
            overallFeelingImageView.heightAnchor.constraint(equalToConstant: 34.scale),
            overallFeelingImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            overallFeelingImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension JournalTableCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(integralRed: 239, green: 239, blue: 244)
        view.layer.cornerRadius = 11.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeDateTimeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeTemperatureLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeOverallFeelingImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
