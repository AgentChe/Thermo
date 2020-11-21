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

        viewModel
            .temperatureRange()
            .drive(onNext: { [weak self] range in
                self?.loggerView.temperatureView.range = range
            })
            .disposed(by: disposeBag)

        loggerView
            .temperatureView
            .continueButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard
                    let unit = self?.loggerView.temperatureView.range?.unit,
                    let temperature = self?.loggerView.temperatureView.value
                else {
                    return
                }
                
                self?.viewModel.selectTemperatureUnit.accept(unit)
                self?.viewModel.selectTemperatureValue.accept(temperature)
                
                self?.loggerView.step = .overallFeeling
            })
            .disposed(by: disposeBag)
        
        loggerView
            .feelView
            .saveButton.rx.tap
            .bind(to: viewModel.create)
            .disposed(by: disposeBag)
        
        viewModel
            .step()
            .drive(onNext: { [weak self] step in
                self?.step(at: step)
            })
            .disposed(by: disposeBag)
        
        addOverallFeelingActions()
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
        loggerView.feelView.overallFeelingView.badItem.addGestureRecognizer(badGesture)
        loggerView.feelView.overallFeelingView.badItem.isUserInteractionEnabled = true
        
        let sickGesture = UITapGestureRecognizer()
        loggerView.feelView.overallFeelingView.sickItem.addGestureRecognizer(sickGesture)
        loggerView.feelView.overallFeelingView.sickItem.isUserInteractionEnabled = true
        
        let goodGesture = UITapGestureRecognizer()
        loggerView.feelView.overallFeelingView.goodItem.addGestureRecognizer(goodGesture)
        loggerView.feelView.overallFeelingView.goodItem.isUserInteractionEnabled = true
        
        let recoveredGesture = UITapGestureRecognizer()
        loggerView.feelView.overallFeelingView.recoveredItem.addGestureRecognizer(recoveredGesture)
        loggerView.feelView.overallFeelingView.recoveredItem.isUserInteractionEnabled = true
        
        Observable
            .merge([
                badGesture.rx.event.map { _ in OverallFeeling.bad },
                sickGesture.rx.event.map { _ in OverallFeeling.sick },
                goodGesture.rx.event.map { _ in OverallFeeling.good },
                recoveredGesture.rx.event.map { _ in OverallFeeling.recovered },
            ])
            .startWith(.good)
            .subscribe(onNext: { [weak self] unit in
                self?.viewModel.selectOverallFeeling.accept(unit)
                self?.update(checked: unit)
            })
            .disposed(by: disposeBag)
    }
    
    func update(checked: OverallFeeling) {
        [
            loggerView.feelView.overallFeelingView.badItem,
            loggerView.feelView.overallFeelingView.sickItem,
            loggerView.feelView.overallFeelingView.goodItem,
            loggerView.feelView.overallFeelingView.recoveredItem
        ]
        .forEach {
            $0.isChecked = false 
        }
        
        switch checked {
        case .good:
            loggerView.feelView.overallFeelingView.goodItem.isChecked = true
        case .bad:
            loggerView.feelView.overallFeelingView.badItem.isChecked = true
        case .sick:
            loggerView.feelView.overallFeelingView.sickItem.isChecked = true
        case .recovered:
            loggerView.feelView.overallFeelingView.recoveredItem.isChecked = true
        }
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
