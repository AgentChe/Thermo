//
//  LoggerViewController.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import UIKit
import RxSwift
import RxCocoa

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
        
        let temperatureRange = viewModel.temperatureRange()
        let currentMember = viewModel.currentMember()

        temperatureRange
            .drive(onNext: { [weak self] range in
                self?.loggerView.temperatureView.range = range
            })
            .disposed(by: disposeBag)
        
        let temperatureRangeAndCurrentMember = Driver
            .combineLatest(temperatureRange, currentMember)

        loggerView
            .temperatureView
            .continueButton.rx.tap
            .withLatestFrom(temperatureRangeAndCurrentMember)
            .subscribe(onNext: { [weak self] stub in
                guard let this = self else {
                    return
                }
                
                let (temperatureRange, currentMember) = stub
                
                this.viewModel.selectTemperatureUnit.accept(temperatureRange.unit)
                this.viewModel.selectTemperatureValue.accept(this.loggerView.temperatureView.value)
                
                switch currentMember.unit {
                case .me, .child, .parent, .other:
                    this.loggerView.step = .overallFeeling
                case .animal, .object:
                    this.viewModel.create.accept(Void())
                }
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
                        LoggerSelectionViewItem(id: $0.id, name: $0.name)
                    }
            })
            .disposed(by: disposeBag)
            
        viewModel
            .symptoms()
            .drive(onNext: { [weak self] models in
                self?.loggerView.feelView.symptomsView.models = models
                    .map {
                        LoggerSelectionViewItem(id: $0.id, name: $0.name)
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
        let style: LoggerSelectionView.Style = viewModel.hasActiveSubscription() ? .cell : .payment

        loggerView.feelView.symptomsView.style = style
        loggerView.feelView.medicinesView.style = style
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
                    let vc = LoggerSelectionController.make(style: .symptoms,
                                                            models: this.loggerView.feelView.symptomsView.models,
                                                            selectedItems: { models in
                        this.viewModel.selectSymptoms.accept(models.map { Symptom(id: $0.id, name: $0.name) })
                                                                
                        this.loggerView.feelView.symptomsView.set(selected: models)
                        this.loggerView.feelView.symptomsView.updateVisibility()
                    })
                    this.navigationController?.pushViewController(vc, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        loggerView.feelView.symptomsView.didRemoveTagView = { [weak self] tagView in
            guard let this = self else {
                return
            }
            
            var storedSymptoms = this.viewModel.selectSymptoms.value
            storedSymptoms.removeAll(where: { $0.id == tagView.model.id })
            this.viewModel.selectSymptoms.accept(storedSymptoms)
            
            this.loggerView.feelView.symptomsView.models.first(where: { $0.id == tagView.model.id })?.isSelected = false
            
            this.loggerView.feelView.symptomsView.tagsView.removeTagView(tagView)
            this.loggerView.feelView.symptomsView.updateVisibility()
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
                    let vc = LoggerSelectionController.make(style: .medicines,
                                                            models: this.loggerView.feelView.medicinesView.models,
                                                            selectedItems: { models in
                        this.viewModel.selectMedicines.accept(models.map { Medicine(id: $0.id, name: $0.name) })
                                                                
                        this.loggerView.feelView.medicinesView.set(selected: models)
                        this.loggerView.feelView.medicinesView.updateVisibility()
                    })
                    this.navigationController?.pushViewController(vc, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        loggerView.feelView.medicinesView.didRemoveTagView = { [weak self] tagView in
            guard let this = self else {
                return
            }
            
            var storedMedicines = this.viewModel.selectMedicines.value
            storedMedicines.removeAll(where: { $0.id == tagView.model.id })
            this.viewModel.selectMedicines.accept(storedMedicines)
            
            this.loggerView.feelView.medicinesView.models.first(where: { $0.id == tagView.model.id })?.isSelected = false
            
            this.loggerView.feelView.medicinesView.tagsView.removeTagView(tagView)
            this.loggerView.feelView.medicinesView.updateVisibility()
        }
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
        case .paygate:
            showPaygate()
        }
    }
    
    func showPaygate() {
        let vc = PaygateViewController.make()
        vc.delegate = self
        present(vc, animated: true)
    }
}
