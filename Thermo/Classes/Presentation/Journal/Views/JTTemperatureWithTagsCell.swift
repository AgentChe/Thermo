//
//  JournalTableTagsCell.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 24.11.2020.
//

import UIKit

final class JTTemperatureWithTagsCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var feelingImageView = makeFeelingImageView()
    lazy var temperatureLabel = makeTemperatureLabel()
    lazy var dateTimeLabel = makeDateTimeLabel()
    lazy var tagsView = makeTagsView()
    
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
extension JTTemperatureWithTagsCell {
    func setup(temperatureWithTags: JTTemperatureWithTags) {
        feelingImageView.image = getFeeling(from: temperatureWithTags)
        temperatureLabel.attributedText = getTemperature(from: temperatureWithTags)
        dateTimeLabel.attributedText = getDateTime(from: temperatureWithTags)

        let views = temperatureWithTags.tags
            .map { tag -> TagView in
                let view = TagView(model: TagViewModel(name: tag))
                view.textColor = UIColor(integralRed: 148, green: 165, blue: 225)
                view.tagBackgroundColor = UIColor(integralRed: 246, green: 246, blue: 224650)
                view.cornerRadius = 4.scale
                view.paddingX = 8.scale
                view.paddingY = 6.scale
                view.textFont = Fonts.Poppins.regular(size: 11.scale)
                return view
            }
        tagsView.set(tagViewList: views)
    }
}

// MARK: Private
private extension JTTemperatureWithTagsCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = .clear
        selectedBackgroundView = selectedView
    }
    
    func getDateTime(from element: JTTemperatureWithTags) -> NSAttributedString {
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

    func getTemperature(from element: JTTemperatureWithTags) -> NSAttributedString {
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

    func getFeeling(from element: JTTemperatureWithTags) -> UIImage? {
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
private extension JTTemperatureWithTagsCell {
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
            temperatureLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 13.scale)
        ])
        
        NSLayoutConstraint.activate([
            dateTimeLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12.scale),
            dateTimeLabel.centerYAnchor.constraint(equalTo: feelingImageView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tagsView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10.scale),
            tagsView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10.scale),
            tagsView.topAnchor.constraint(equalTo: container.topAnchor, constant: 50.scale),
            tagsView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -11.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension JTTemperatureWithTagsCell {
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
    
    func makeTagsView() -> TagListView {
        let view = TagListView()
        view.frame.size = CGSize(width: 295.scale, height: 27.scale)
        view.backgroundColor = UIColor.clear
        view.marginX = 8.scale
        view.marginY = 6.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
