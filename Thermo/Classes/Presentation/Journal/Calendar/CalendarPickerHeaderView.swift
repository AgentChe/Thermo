//
//  CalendarPickerHeaderView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 10.02.2021.
//

import UIKit

final class CalendarPickerHeaderView: UIView {
    lazy var monthLabel = makeMonthLabel()
    lazy var dayOfWeekStackView = makeDayOfWeekStackView()
    lazy var leftButton = makeLeftButton()
    lazy var rightButton = makeRightButton()

    var baseDate = Date() {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.locale = Locale.autoupdatingCurrent
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMM y")
            
            monthLabel.text = dateFormatter.string(from: baseDate)
        }
    }
    
    private let didTapLastMonthCompletionHandler: (() -> Void)
    private let didTapNextMonthCompletionHandler: (() -> Void)

    init(didTapLastMonthCompletionHandler: @escaping (() -> Void),
         didTapNextMonthCompletionHandler: @escaping (() -> Void)) {
        self.didTapLastMonthCompletionHandler = didTapLastMonthCompletionHandler
        self.didTapNextMonthCompletionHandler = didTapNextMonthCompletionHandler
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
        addWeekdays()
  }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension CalendarPickerHeaderView {
    func initialize() {
        translatesAutoresizingMaskIntoConstraints = false

        backgroundColor = UIColor.white

        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = 15.scale
    }
    
    func addWeekdays() {
        for dayNumber in 1...7 {
            let dayLabel = UILabel()
            dayLabel.font = Fonts.Poppins.semiBold(size: 13.scale)
            dayLabel.textColor = UIColor(integralRed: 60, green: 60, blue: 67, alpha: 0.3)
            dayLabel.textAlignment = .center
            dayLabel.text = dayOfWeekLetter(for: dayNumber)
            dayOfWeekStackView.addArrangedSubview(dayLabel)
        }
    }
    
    @objc
    func didTapPreviousMonthButton() {
        didTapLastMonthCompletionHandler()
    }

    @objc
    func didTapNextMonthButton() {
        didTapNextMonthCompletionHandler()
    }

    private func dayOfWeekLetter(for dayNumber: Int) -> String {
        switch dayNumber {
        case 1:
            return "Sunday.Short".localized.uppercased()
        case 2:
            return "Monday.Short".localized.uppercased()
        case 3:
            return "Tuesday.Short".localized.uppercased()
        case 4:
            return "Wednesday.Short".localized.uppercased()
        case 5:
            return "Thursday.Short".localized.uppercased()
        case 6:
            return "Saturday.Short".localized.uppercased()
        case 7:
            return "Monday.Short".localized.uppercased()
        default:
            return ""
        }
    }
}

// MARK: Make constraints
private extension CalendarPickerHeaderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            monthLabel.topAnchor.constraint(equalTo: topAnchor, constant: 17.scale),
            monthLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            monthLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50.scale)
        ])
        
        NSLayoutConstraint.activate([
            dayOfWeekStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dayOfWeekStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dayOfWeekStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5.scale)
        ])
        
        NSLayoutConstraint.activate([
            rightButton.widthAnchor.constraint(equalToConstant: 10.scale),
            rightButton.heightAnchor.constraint(equalToConstant: 17.scale),
            rightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17.scale),
            rightButton.centerYAnchor.constraint(equalTo: monthLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            leftButton.widthAnchor.constraint(equalToConstant: 10.scale),
            leftButton.heightAnchor.constraint(equalToConstant: 17.scale),
            leftButton.trailingAnchor.constraint(equalTo: rightButton.leadingAnchor, constant: -31.scale),
            leftButton.centerYAnchor.constraint(equalTo: monthLabel.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CalendarPickerHeaderView {
    func makeMonthLabel() -> UILabel {
        let view = UILabel()
        view.textColor = UIColor(integralRed: 148, green: 165, blue: 225)
        view.font = Fonts.Poppins.semiBold(size: 20.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDayOfWeekStackView() -> UIStackView {
        let view = UIStackView()
        view.distribution = .fillEqually
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLeftButton() -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: "Calendar.LeftArrow"), for: .normal)
        view.addTarget(self, action: #selector(didTapPreviousMonthButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeRightButton() -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: "Calendar.RightArrow"), for: .normal)
        view.addTarget(self, action: #selector(didTapNextMonthButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
