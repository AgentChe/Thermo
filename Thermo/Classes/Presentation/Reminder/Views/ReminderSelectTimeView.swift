//
//  ReminderSelectTimeView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 03.11.2020.
//

import UIKit

final class ReminderSelectTimeView: UIView {
    lazy var timePicker = makeTimePicker()
    lazy var button = makeButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension ReminderSelectTimeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            timePicker.centerXAnchor.constraint(equalTo: centerXAnchor),
            timePicker.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 45.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -45.scale),
            button.heightAnchor.constraint(equalToConstant: 48.scale),
            button.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 24.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ReminderSelectTimeView {
    func makeTimePicker() -> UIDatePicker {
        let view = UIDatePicker()
        view.setValue(UIColor.white, forKeyPath: "textColor")
        view.datePickerMode = .countDownTimer
        view.datePickerMode = .time
        view.timeZone = NSTimeZone.local
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let view = UIButton()
        view.setTitle("OK".localized, for: .normal)
        view.setTitleColor(UIColor(integralRed: 50, green: 50, blue: 52), for: .normal)
        view.titleLabel?.font = Fonts.Poppins.semiBold(size: 17.scale)
        view.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        view.layer.cornerRadius = 16.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
