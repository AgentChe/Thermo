//
//  JournalTableCell.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import UIKit

final class JournalTableCell: UITableViewCell {
    lazy var dateTimeLabel = makeDateTimeLabel()
    lazy var temperatureLabel = makeTemperatureLabel()
    lazy var overallFeelingEmojiView = makeOverallFeelingEmojiView()
    
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
    func setup(report: JTReport) {
        dateTimeLabel.attributedText = dateTime(from: report)
        temperatureLabel.attributedText = temperature(from: report)
        overallFeelingEmojiView.text = overallFeeling(from: report)
    }
    
    func dateTime(from report: JTReport) -> NSAttributedString {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd MMM,  "
        let date = dateFormatter
            .string(from: report.date)
            .attributed(with: TextAttributes()
                            .textColor(UIColor(integralRed: 50, green: 50, blue: 52))
                            .font(Fonts.Poppins.regular(size: 17.scale))
                            .lineHeight(22.scale)
                            .letterSpacing(-0.4.scale)
                            .textAlignment(.center))
        
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter
            .string(from: report.date)
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
    
    func temperature(from report: JTReport) -> NSAttributedString {
        let coldTemperature: Double
        let fireTemperature: Double
        
        let unit: String
        switch report.unit {
        case .fahrenheit:
            coldTemperature = 96.8
            fireTemperature = 98.78
            
            unit = "Fahrenheit".localized
        case .celsius:
            coldTemperature = 36.0
            fireTemperature = 37.1
            
            unit = "Celsius".localized
        }
        
        let color: UIColor
        if report.temperature > fireTemperature {
            color = UIColor(integralRed: 255, green: 126, blue: 103)
        } else if report.temperature < coldTemperature {
            color = UIColor(integralRed: 108, green: 22, blue: 245)
        } else {
            color = UIColor(integralRed: 50, green: 50, blue: 52)
        }
        
        return String(format: "%.1f %@", report.temperature, unit)
            .attributed(with: TextAttributes()
                            .textColor(color)
                            .font(Fonts.Poppins.regular(size: 20.scale))
                            .lineHeight(25.scale))
    }
    
    func overallFeeling(from report: JTReport) -> String {
        switch report.overallFeeiling {
        case .bad:
            return "😞"
        case .sick:
            return "🤒"
        case .good:
            return "😀"
        case .recovered:
            return "😇"
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
            dateTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24.scale),
            dateTimeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            temperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -81.scale),
            temperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            overallFeelingEmojiView.widthAnchor.constraint(equalToConstant: 34.scale),
            overallFeelingEmojiView.heightAnchor.constraint(equalToConstant: 34.scale),
            overallFeelingEmojiView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            overallFeelingEmojiView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension JournalTableCell {
    func makeDateTimeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTemperatureLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeOverallFeelingEmojiView() -> UILabel {
        let view = UILabel()
        view.font = Fonts.Poppins.regular(size: 32.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
