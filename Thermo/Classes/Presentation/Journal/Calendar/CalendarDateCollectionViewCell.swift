//
//  CalendarDateCollectionViewCell.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 10.02.2021.
//

import UIKit

final class CalendarDateCollectionViewCell: UICollectionViewCell {
    lazy var selectionBackgroundView = makeSelectionBackgroundView()
    lazy var numberLabel = makeNumberLabel()

    var day: Day? {
        didSet {
            guard let day = day else {
                return
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.setLocalizedDateFormatFromTemplate("EEEE, MMMM d")

            numberLabel.text = day.number
            accessibilityLabel = dateFormatter.string(from: day.date)
            updateSelectionStatus()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        isAccessibilityElement = true
        accessibilityTraits = .button

        contentView.addSubview(selectionBackgroundView)
        contentView.addSubview(numberLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.deactivate(selectionBackgroundView.constraints)

        NSLayoutConstraint.activate([
            numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            selectionBackgroundView.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor),
            selectionBackgroundView.centerXAnchor.constraint(equalTo: numberLabel.centerXAnchor),
            selectionBackgroundView.widthAnchor.constraint(equalToConstant: 32.scale),
            selectionBackgroundView.heightAnchor.constraint(equalToConstant: 32.scale)
        ])

        selectionBackgroundView.layer.cornerRadius = 16.scale
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        layoutSubviews()
    }
}

// MARK: Private
private extension CalendarDateCollectionViewCell {
    func updateSelectionStatus() {
        guard let day = day else {
            return
        }
        
        numberLabel.textColor = day.isSelected ? UIColor.white : UIColor(integralRed: 148, green: 165, blue: 225)
        selectionBackgroundView.isHidden = !day.isSelected
    }
}

// MARK: Lazy initialization
private extension CalendarDateCollectionViewCell {
    func makeSelectionBackgroundView() -> UIView {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = UIColor(integralRed: 148, green: 165, blue: 225)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    func makeNumberLabel() -> UILabel {
        let view = UILabel()
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        view.textColor = UIColor(integralRed: 148, green: 165, blue: 225)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
