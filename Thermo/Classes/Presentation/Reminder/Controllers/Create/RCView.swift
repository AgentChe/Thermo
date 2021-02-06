//
//  RCView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 04.02.2021.
//

import UIKit

final class RCView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var timePicker = makeTimePicker()
    lazy var mondayCell = makeCell(text: "Monday".localized, weekday: .monday)
    lazy var tuesdayCell = makeCell(text: "Tuesday".localized, weekday: .tuesday)
    lazy var wednesdayCell = makeCell(text: "Wednesday".localized, weekday: .wednesday)
    lazy var thursdayCell = makeCell(text: "Thursday".localized, weekday: .thursday)
    lazy var fridayCell = makeCell(text: "Friday".localized, weekday: .friday)
    lazy var saturdayCell = makeCell(text: "Saturday".localized, weekday: .saturday)
    lazy var sundayCell = makeCell(text: "Sunday".localized, weekday: .sunday)
    lazy var button = makeButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension RCView {
    func initialize() {
        backgroundColor = UIColor(integralRed: 246, green: 246, blue: 246)
    }
}

// MARK: Make constraints
private extension RCView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 85.scale : 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            timePicker.leadingAnchor.constraint(equalTo: leadingAnchor),
            timePicker.heightAnchor.constraint(equalToConstant: 148.scale),
            timePicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 39.scale : 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            mondayCell.leadingAnchor.constraint(equalTo: leadingAnchor),
            mondayCell.trailingAnchor.constraint(equalTo: trailingAnchor),
            mondayCell.heightAnchor.constraint(equalToConstant: 25.scale),
            mondayCell.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 40.scale : 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            tuesdayCell.leadingAnchor.constraint(equalTo: leadingAnchor),
            tuesdayCell.trailingAnchor.constraint(equalTo: trailingAnchor),
            tuesdayCell.heightAnchor.constraint(equalToConstant: 25.scale),
            tuesdayCell.topAnchor.constraint(equalTo: mondayCell.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            wednesdayCell.leadingAnchor.constraint(equalTo: leadingAnchor),
            wednesdayCell.trailingAnchor.constraint(equalTo: trailingAnchor),
            wednesdayCell.heightAnchor.constraint(equalToConstant: 25.scale),
            wednesdayCell.topAnchor.constraint(equalTo: tuesdayCell.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            thursdayCell.leadingAnchor.constraint(equalTo: leadingAnchor),
            thursdayCell.trailingAnchor.constraint(equalTo: trailingAnchor),
            thursdayCell.heightAnchor.constraint(equalToConstant: 25.scale),
            thursdayCell.topAnchor.constraint(equalTo: wednesdayCell.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            fridayCell.leadingAnchor.constraint(equalTo: leadingAnchor),
            fridayCell.trailingAnchor.constraint(equalTo: trailingAnchor),
            fridayCell.heightAnchor.constraint(equalToConstant: 25.scale),
            fridayCell.topAnchor.constraint(equalTo: thursdayCell.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            saturdayCell.leadingAnchor.constraint(equalTo: leadingAnchor),
            saturdayCell.trailingAnchor.constraint(equalTo: trailingAnchor),
            saturdayCell.heightAnchor.constraint(equalToConstant: 25.scale),
            saturdayCell.topAnchor.constraint(equalTo: fridayCell.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            sundayCell.leadingAnchor.constraint(equalTo: leadingAnchor),
            sundayCell.trailingAnchor.constraint(equalTo: trailingAnchor),
            sundayCell.heightAnchor.constraint(equalToConstant: 25.scale),
            sundayCell.topAnchor.constraint(equalTo: saturdayCell.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 180.scale),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.heightAnchor.constraint(equalToConstant: 56.scale),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -50.scale : -20.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension RCView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 50, green: 50, blue: 52))
            .font(Fonts.Poppins.bold(size: 30.scale))
            .lineHeight(34.scale)
        
        let view = UILabel()
        view.attributedText = "Reminder.Create.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTimePicker() -> UIDatePicker {
        let view = UIDatePicker()
        if #available(iOS 13.4, *) {
            view.preferredDatePickerStyle = .wheels
        }
        view.backgroundColor = UIColor.clear
        view.setValue(UIColor(integralRed: 97, green: 97, blue: 97), forKeyPath: "textColor")
        view.datePickerMode = .countDownTimer
        view.datePickerMode = .time
        view.timeZone = NSTimeZone.local
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell(text: String, weekday: Weekday) -> RCCell {
        let view = RCCell(weekday: weekday)
        view.isChecked = false
        view.label.text = text
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .font(Fonts.Poppins.semiBold(size: 17.scale))
            .textColor(UIColor.white)
        
        let view = UIButton()
        view.layer.cornerRadius = 28.scale
        view.backgroundColor = UIColor(integralRed: 148, green: 165, blue: 225)
        view.setAttributedTitle("Reminder.Create.Button".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
