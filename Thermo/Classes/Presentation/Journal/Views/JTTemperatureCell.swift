//
//  JournalTableCell.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import UIKit

final class JTTemperatureCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var feelingImageView = makeFeelingImageView()
    lazy var temperatureLabel = makeTemperatureLabel()
    lazy var dateTimeLabel = makeDateTimeLabel()
    
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
extension JTTemperatureCell {
    func setup(temperature: JTTemperature) {
        feelingImageView.image = getFeeling(from: temperature)
        temperatureLabel.attributedText = getTemperature(from: temperature)
        dateTimeLabel.attributedText = getDateTime(from: temperature)
    }
}

// MARK: Private
private extension JTTemperatureCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = .clear
        selectedBackgroundView = selectedView
    }
    
    func getDateTime(from element: JTTemperature) -> NSAttributedString {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM,  HH:mm"
        
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 189, green: 189, blue: 189))
            .font(Fonts.Poppins.regular(size: 15.scale))
            .lineHeight(27.scale)
            .letterSpacing(-0.4.scale)
        
        let date = dateFormatter.string(from: element.date)
        
        return date.attributed(with: attrs)
    }

    func getTemperature(from element: JTTemperature) -> NSAttributedString {
        let temperature = element.temperature
        
        let unit: String
        switch temperature.unit {
        case .fahrenheit:
            unit = "Fahrenheit".localized
        case .celsius:
            unit = "Celsius".localized
        }

        return String(format: "%.1f %@", temperature.value, unit)
            .attributed(with: TextAttributes()
                            .textColor(UIColor(integralRed: 50, green: 50, blue: 52))
                            .font(Fonts.Poppins.regular(size: 20.scale))
                            .lineHeight(25.scale))
    }

    func getFeeling(from element: JTTemperature) -> UIImage? {
        switch element.feeling {
        case .bad:
            return UIImage(named: "Feeling.Bad")
        case .sick:
            return UIImage(named: "Feeling.Sick")
        case .good:
            return UIImage(named: "Feeling.Good")
        case .recovered:
            return UIImage(named: "Feeling.Recovered")
        }
    }
}

// MARK: Make constraints
private extension JTTemperatureCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.scale)
        ])
        
        NSLayoutConstraint.activate([
            feelingImageView.widthAnchor.constraint(equalToConstant: 30.scale),
            feelingImageView.heightAnchor.constraint(equalToConstant: 30.scale),
            feelingImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 10.scale),
            feelingImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            temperatureLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 50.scale),
            temperatureLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 13.scale),
            temperatureLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -13.scale)
        ])
        
        NSLayoutConstraint.activate([
            dateTimeLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12.scale),
            dateTimeLabel.centerYAnchor.constraint(equalTo: feelingImageView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension JTTemperatureCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 11.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeFeelingImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
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
    
    func makeDateTimeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
