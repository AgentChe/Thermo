//
//  LMView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 08.02.2021.
//

import UIKit

final class LMView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var temperaturePicker = makeTemperaturePicker()
    lazy var continueButton = makeContinueButton()
    
    var range: TemperatureRange? {
        didSet {
            start()
        }
    }
    
    private(set) var value: Double = 0
    
    private var temperatures = [Double]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UIPickerViewDelegate
extension LMView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let attrs = TextAttributes()
            .font(Fonts.OpenSans.bold(size: 68.scale))
            .lineHeight(75.scale)
            .textColor(UIColor(integralRed: 148, green: 165, blue: 225))
            .textAlignment(.center)
        
        let text = String(format: "%.1f", temperatures[row])
            .attributed(with: attrs)
        
        let view = UILabel()
        view.backgroundColor = UIColor.clear
        view.attributedText = text
        
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        75.scale
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        value = temperatures[row]
    }
}

// MARK: UIPickerViewDataSource
extension LMView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        temperatures.count
    }
}

// MARK: Private
private extension LMView {
    func initialize() {
        backgroundColor = UIColor(integralRed: 246, green: 246, blue: 246)
    }
    
    func start() {
        value = range?.normal ?? 0
        
        updatePicker()
    }
        
    func updatePicker() {
        guard let range = self.range else {
            return
        }
        
        for value in stride(from: range.min, to: range.max + range.step, by: range.step) {
            temperatures.append(value)
        }
        
        temperaturePicker.reloadAllComponents()
        
        if let initialIndex = temperatures.firstIndex(of: range.normal) {
            temperaturePicker.selectRow(initialIndex, inComponent: 0, animated: false)
        }
    }
}

// MARK: Make constraints
private extension LMView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 130.scale : 70.scale)
        ])
        
        NSLayoutConstraint.activate([
            temperaturePicker.centerXAnchor.constraint(equalTo: centerXAnchor),
            temperaturePicker.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 384.scale : 384.scale),
            temperaturePicker.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: ScreenSize.isIphoneXFamily ? -100.scale : -60.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.widthAnchor.constraint(equalToConstant: 180.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 56.scale),
            continueButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -50.scale : -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension LMView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 50, green: 50, blue: 52))
            .font(Fonts.OpenSans.bold(size: 34.scale))
            .textAlignment(.center)
            .lineHeight(40.scale)
    
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "LM.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
        
    func makeTemperaturePicker() -> UIPickerView {
        let view = UIPickerView()
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
        
    func makeContinueButton() -> UIButton {
        let attrs = TextAttributes()
            .font(Fonts.Poppins.semiBold(size: 17.scale))
            .textColor(UIColor.white)
            .lineHeight(22.scale)
        
        let view = UIButton()
        view.layer.cornerRadius = 28.scale
        view.backgroundColor = UIColor(integralRed: 148, green: 165, blue: 225)
        view.setAttributedTitle("LM.Button".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
