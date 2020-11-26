//
//  AMDateBirthdayView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 20.11.2020.
//

import UIKit

final class AMDateBirthdayView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var dialogView = makeDialogView()
    lazy var dialogTitleLabel = makeDialogTitleLabel()
    lazy var dialogSubTitleLabel = makeDialogSubTitleLabel()
    lazy var upperSeparator = makeDialogSeparatorView()
    lazy var datePicker = makeDialogDatePicker()
    lazy var bottomSeparator = makeDialogSeparatorView()
    lazy var dialogButton = makeDialogButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension AMDateBirthdayView {
    func setup(with selectedUnit: AMMemberUnit) {
        let attrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.OpenSans.bold(size: 34.scale))
            .lineHeight(37.scale)
        
        let title: String
        switch selectedUnit {
        case .me:
            title = "AddMember.DateBirthday.TileForMeUnit".localized
        case .child, .other, .parent, .animal, .object:
            title = "AddMember.DateBirthday.TileForNotMeUnit".localized
        }
        
        titleLabel.attributedText = title.localized.attributed(with: attrs)
    }
}

// MARK: Make constraints
private extension AMDateBirthdayView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 120.scale : 60.scale)
        ])
        
        NSLayoutConstraint.activate([
            dialogView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.scale),
            dialogView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.scale),
            dialogView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 36.scale)
        ])
        
        NSLayoutConstraint.activate([
            dialogTitleLabel.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor, constant: 16.scale),
            dialogTitleLabel.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor, constant: -16.scale),
            dialogTitleLabel.topAnchor.constraint(equalTo: dialogView.topAnchor, constant: 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            dialogSubTitleLabel.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor, constant: 16.scale),
            dialogSubTitleLabel.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor, constant: -16.scale),
            dialogSubTitleLabel.topAnchor.constraint(equalTo: dialogTitleLabel.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            upperSeparator.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor),
            upperSeparator.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor),
            upperSeparator.topAnchor.constraint(equalTo: dialogSubTitleLabel.bottomAnchor, constant: 17.scale),
            upperSeparator.heightAnchor.constraint(equalToConstant: 1.scale)
        ])
        
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor),
            datePicker.topAnchor.constraint(equalTo: upperSeparator.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            bottomSeparator.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor),
            bottomSeparator.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor),
            bottomSeparator.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 16.scale),
            bottomSeparator.heightAnchor.constraint(equalToConstant: 1.scale)
        ])
        
        NSLayoutConstraint.activate([
            dialogButton.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor),
            dialogButton.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor),
            dialogButton.topAnchor.constraint(equalTo: bottomSeparator.bottomAnchor),
            dialogButton.bottomAnchor.constraint(equalTo: dialogView.bottomAnchor),
            dialogButton.heightAnchor.constraint(equalToConstant: 58.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension AMDateBirthdayView {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDialogView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 13.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDialogTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 154, green: 153, blue: 162))
            .font(Fonts.Poppins.bold(size: 13.scale))
            .lineHeight(18.scale)
            .letterSpacing(-0.08.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "AddMember.DateBirthday.DialogTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        dialogView.addSubview(view)
        return view
    }
    
    func makeDialogSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 154, green: 153, blue: 162))
            .font(Fonts.Poppins.regular(size: 13.scale))
            .lineHeight(18.scale)
            .letterSpacing(-0.08.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "AddMember.DateBirthday.DialogSubTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        dialogView.addSubview(view)
        return view
    }
    
    func makeDialogDatePicker() -> UIDatePicker {
        let view = UIDatePicker()
        if #available(iOS 13.4, *) {
            view.preferredDatePickerStyle = .wheels
        }
        view.backgroundColor = UIColor.clear
        view.maximumDate = Calendar.current.date(byAdding: .year, value: -8, to: Date())
        view.minimumDate = Calendar.current.date(byAdding: .year, value: -80, to: Date())
        view.setValue(UIColor.black, forKeyPath: "textColor")
        view.datePickerMode = .countDownTimer
        view.datePickerMode = .date
        view.timeZone = NSTimeZone.local
        view.date = Calendar.current.date(byAdding: .year, value: -20, to: Date()) ?? Date()
        view.translatesAutoresizingMaskIntoConstraints = false
        dialogView.addSubview(view)
        return view
    }
    
    func makeDialogSeparatorView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(integralRed: 230, green: 228, blue: 234)
        view.translatesAutoresizingMaskIntoConstraints = false
        dialogView.addSubview(view)
        return view
    }
    
    func makeDialogButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 2, green: 13, blue: 14))
            .font(Fonts.Poppins.semiBold(size: 17.scale))
            .lineHeight(22.scale)
            .letterSpacing(-0.41.scale)
            .textAlignment(.center)
        
        let view = UIButton()
        view.setAttributedTitle("AddMember.DateBirthday.DialogButton".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        dialogView.addSubview(view)
        return view
    }
}
