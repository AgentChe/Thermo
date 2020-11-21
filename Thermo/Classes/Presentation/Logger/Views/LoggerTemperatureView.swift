//
//  LoggerTemperatureView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import UIKit

final class LoggerTemperatureView: GradientView {
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
        
        configure()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UIPickerViewDelegate
extension LoggerTemperatureView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let attrs = TextAttributes()
            .font(Fonts.OpenSans.bold(size: 68.scale))
            .lineHeight(75.scale)
            .textColor(UIColor.white)
            .textAlignment(.center)
        
        let text = String(format: "%.1f", temperatures[row])
            .attributed(with: attrs)
        
        let view = UILabel()
        view.backgroundColor = UIColor.clear
        view.attributedText = text
        
        updateColors(current: temperatures[row])
        
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
extension LoggerTemperatureView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        temperatures.count
    }
}

// MARK: Private
private extension LoggerTemperatureView {
    func configure() {
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
    }
    
    func start() {
        value = range?.normal ?? 0
        
        updateColors(current: value)
        updatePicker()
    }
    
    func updatePicker() {
        guard let range = self.range else {
            return
        }
        
        for value in stride(from: range.min, to: range.max + 0.1, by: 0.1) {
            temperatures.append(value)
        }
        
        temperaturePicker.reloadAllComponents()
        
        if let initialIndex = temperatures.firstIndex(of: range.normal) {
            temperaturePicker.selectRow(initialIndex, inComponent: 0, animated: false)
        }
    }
    
    func updateColors(current: Double) {
        guard let range = self.range else {
            return
        }
        
        let topRed = calculateColor(min: 108, max: 255, range: range, current: current) + 108
        let bottomRed = calculateColor(min: 53, max: 255, range: range, current: current) + 108
        let topBlue = 255 - calculateColor(min: 108, max: 255, range: range, current: current)
        let bottomBlue = 255 - calculateColor(min: 53, max: 255, range: range, current: current)
        
        gradientLayer.colors = [
            UIColor(integralRed: topRed, green: 0, blue: topBlue).cgColor,
            UIColor(integralRed: bottomRed, green: 150, blue: bottomBlue).cgColor
        ]
    }
    
    func calculateColor(min: CGFloat, max: CGFloat, range: TemperatureRange, current: Double) -> CGFloat {
        let temperatureDiff = CGFloat(range.max - range.min)
        let colorsDiff = max - min
        let colorUnitForOneDegree = colorsDiff / temperatureDiff
        return CGFloat(current - range.min) * colorUnitForOneDegree
    }
}

// MARK: Make constraints
private extension LoggerTemperatureView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 191.scale : 100.scale)
        ])
        
        NSLayoutConstraint.activate([
            temperaturePicker.centerXAnchor.constraint(equalTo: centerXAnchor),
            temperaturePicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50.scale),
            temperaturePicker.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: ScreenSize.isIphoneXFamily ? -100.scale : -60.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.widthAnchor.constraint(equalToConstant: 180.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 56.scale),
            continueButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -80.scale : -40.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension LoggerTemperatureView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.OpenSans.bold(size: 34.scale))
            .textAlignment(.center)
            .lineHeight(41.scale)
    
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "TemperatureLogger.Temperature.Title".localized.attributed(with: attrs)
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
            .textColor(UIColor.black)
            .font(Fonts.Poppins.semiBold(size: 17.scale))
            .lineHeight(22.scale)
        
        let view = UIButton()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 28.scale
        view.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
