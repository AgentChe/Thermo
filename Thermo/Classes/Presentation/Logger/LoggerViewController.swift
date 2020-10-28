//
//  LoggerViewController.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import UIKit
import RxSwift

final class LoggerViewController: UIViewController {
    var loggerView = LoggerView()
    
    private let viewModel = LoggerViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = loggerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addOverallFeelingActions()

        viewModel
            .temperatureRange()
            .drive(onNext: { [weak self] range in
                self?.loggerView.loggerTemperatureView.range = range
            })
            .disposed(by: disposeBag)

        loggerView
            .loggerTemperatureView
            .continueButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard
                    let unit = self?.loggerView.loggerTemperatureView.range?.unit,
                    let temperature = self?.loggerView.loggerTemperatureView.value
                else {
                    return
                }
                
                let value = (temperature, unit)
                
                self?.viewModel.selectTemperature.accept(value)
                
                self?.loggerView.step = .overallFeeling
            })
            .disposed(by: disposeBag)
        
        viewModel
            .step()
            .drive(onNext: { [weak self] step in
                self?.step(at: step)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension LoggerViewController {
    static func make() -> LoggerViewController {
        LoggerViewController()
    }
}

// MARK: Private
private extension LoggerViewController {
    func addOverallFeelingActions() {
        let badGesture = UITapGestureRecognizer()
        loggerView.overallFeelingView.badItem.addGestureRecognizer(badGesture)
        loggerView.overallFeelingView.badItem.isUserInteractionEnabled = true
        
        let mehGesture = UITapGestureRecognizer()
        loggerView.overallFeelingView.mehItem.addGestureRecognizer(mehGesture)
        loggerView.overallFeelingView.mehItem.isUserInteractionEnabled = true
        
        let goodGesture = UITapGestureRecognizer()
        loggerView.overallFeelingView.goodItem.addGestureRecognizer(goodGesture)
        loggerView.overallFeelingView.goodItem.isUserInteractionEnabled = true
        
        Observable
            .merge([
                badGesture.rx.event.map { _ in OverallFeeling.bad },
                mehGesture.rx.event.map { _ in OverallFeeling.meh },
                goodGesture.rx.event.map { _ in OverallFeeling.good }
            ])
            .subscribe(onNext: { [weak self] unit in
                self?.viewModel.selectOverallFeeling.accept(unit)
            })
            .disposed(by: disposeBag)
    }
    
    func step(at step: LoggerViewModel.Step) {
        switch step {
        case .logged:
            navigationController?.popViewController(animated: true)
        case .error(let message):
            Toast.notify(with: message, style: .danger)
        }
    }
}
