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
        
        viewModel
            .medicines()
            .drive(onNext: { [weak self] models in
                self?.loggerView.feelView.medicinesView.models = models
                    .map {
                        ComboBoxModel(id: $0.id, name: $0.name)
                    }
            })
            .disposed(by: disposeBag)
            
        viewModel
            .symptoms()
            .drive(onNext: { [weak self] models in
                self?.loggerView.feelView.symptomsView.models = models
                    .map {
                        ComboBoxModel(id: $0.id, name: $0.name)
                    }
            })
            .disposed(by: disposeBag)
        
        addOverallFeelingActions()
        updatePaymentBlocks()
        addActionsToSymptomsBlocks()
        addActionsToMedicinesBlocks()
    }
}

// MARK: Make
extension LoggerViewController {
    static func make() -> LoggerViewController {
        LoggerViewController()
    }
}

// MARK: PaygateViewControllerDelegate
extension LoggerViewController: PaygateViewControllerDelegate {
    func paygateDidClosed(with result: PaygateViewControllerResult) {
        updatePaymentBlocks()
    }
}

// MARK: Private
private extension LoggerViewController {
    func updatePaymentBlocks() {
        let comboBoxStyle: ComboBox.Style = viewModel.hasActiveSubscription() ? .cell : .payment

        // TODO
        loggerView.feelView.symptomsView.style = .cell
        loggerView.feelView.medicinesView.style = .cell
    }
    
    func addActionsToSymptomsBlocks() {
        let tapGesture = UITapGestureRecognizer()
        loggerView.feelView.symptomsView.fieldBackgroundView.isUserInteractionEnabled = true
        loggerView.feelView.symptomsView.fieldBackgroundView.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .subscribe(onNext: { [weak self] event in
                guard let this = self else {
                    return
                }
                
                switch this.loggerView.feelView.symptomsView.style {
                case .payment:
                    this.showPaygate()
                case .cell:
                    this.loggerView.feelView.symptomsView.style = .expanded
                case .expanded:
                    this.loggerView.feelView.symptomsView.style = .cell
                }
                
                this.loggerView.feelView.symptomsView.invalidateIntrinsicContentSize()
                this.loggerView.feelView.symptomsView.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
        
        loggerView.feelView.symptomsView.didSelect = { [weak self] model in
            guard let this = self else {
                return
            }
            
            model.isSelected = true
            
            this.loggerView.feelView.symptomsView.addTagView(model: model)
            this.loggerView.feelView.symptomsView.updateVisibility()
            this.loggerView.feelView.symptomsView.tableView?.reloadData()
            
            var storedSymptoms = this.viewModel.selectSymptoms.value
            storedSymptoms.append(Symptom(id: model.id, name: model.name))
            this.viewModel.selectSymptoms.accept(storedSymptoms)
        }
        
        loggerView.feelView.symptomsView.didRemoveTagView = { [weak self] tagView in
            guard let this = self else {
                return
            }
            
            var storedSymptoms = this.viewModel.selectSymptoms.value
            storedSymptoms.removeAll(where: { $0.id == tagView.model.id })
            this.viewModel.selectSymptoms.accept(storedSymptoms)
            
            this.loggerView.feelView.symptomsView.models.first(where: { $0.id == tagView.model.id })?.isSelected = false
            
            this.loggerView.feelView.symptomsView.tagsView.removeTagView(tagView)
            this.loggerView.feelView.symptomsView.tagsView.layoutIfNeeded()
            this.loggerView.feelView.symptomsView.updateVisibility()
            this.loggerView.feelView.symptomsView.tableView?.reloadData()
        }
    }
    
    func addActionsToMedicinesBlocks() {
        let tapGesture = UITapGestureRecognizer()
        loggerView.feelView.medicinesView.fieldBackgroundView.isUserInteractionEnabled = true
        loggerView.feelView.medicinesView.fieldBackgroundView.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .subscribe(onNext: { [weak self] event in
                guard let this = self else {
                    return
                }
                
                switch this.loggerView.feelView.medicinesView.style {
                case .payment:
                    this.showPaygate()
                case .cell:
                    this.loggerView.feelView.medicinesView.style = .expanded
                case .expanded:
                    this.loggerView.feelView.medicinesView.style = .cell
                }
                
                this.loggerView.feelView.medicinesView.invalidateIntrinsicContentSize()
                this.loggerView.feelView.medicinesView.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
        
        loggerView.feelView.medicinesView.didSelect = { [weak self] model in
            guard let this = self else {
                return
            }
            
            model.isSelected = true
            
            this.loggerView.feelView.medicinesView.addTagView(model: model)
            this.loggerView.feelView.medicinesView.updateVisibility()
            this.loggerView.feelView.medicinesView.tableView?.reloadData()
            
            var storedMedicines = this.viewModel.selectMedicines.value
            storedMedicines.append(Medicine(id: model.id, name: model.name))
            this.viewModel.selectMedicines.accept(storedMedicines)
        }
        
        loggerView.feelView.medicinesView.didRemoveTagView = { [weak self] tagView in
            guard let this = self else {
                return
            }
            
            var storedMedicines = this.viewModel.selectMedicines.value
            storedMedicines.removeAll(where: { $0.id == tagView.model.id })
            this.viewModel.selectMedicines.accept(storedMedicines)
            
            this.loggerView.feelView.medicinesView.models.first(where: { $0.id == tagView.model.id })?.isSelected = false
            
            this.loggerView.feelView.medicinesView.tagsView.removeTagView(tagView)
            this.loggerView.feelView.medicinesView.tagsView.layoutIfNeeded()
            this.loggerView.feelView.medicinesView.updateVisibility()
            this.loggerView.feelView.medicinesView.tableView?.reloadData()
        }
    }
    
    func showPaygate() {
        let vc = PaygateViewController.make()
        vc.delegate = self
        present(vc, animated: true)
    }
    
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
