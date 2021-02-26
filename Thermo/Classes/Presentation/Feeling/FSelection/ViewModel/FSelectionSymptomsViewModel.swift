//
//  FSelectionSymptomsViewModel.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 07.02.2021.
//

import RxSwift
import RxCocoa

final class FSelectionSymptomsViewModel: FSelectionViewModel {
    lazy var save = PublishRelay<[FSelectionTableElement]>()
    
    private lazy var symptomsManager = SymptomsManagerCore()
    private lazy var sessionManager = SessionManagerCore()
    private lazy var monetizationManager = MonetizationManagerCore()
    
    lazy var elements = makeElements()
    lazy var step = makeStep()
}

// MARK: Private
private extension FSelectionSymptomsViewModel {
    func makeElements() -> Driver<[FSelectionTableElement]> {
        let all = symptomsManager
            .rxRetrieveSymptoms(forceUpdate: false)
        
        let selected = symptomsManager
            .rxGetSelectedSymptoms()
        
        return Single
            .zip(all, selected)
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .map { stub -> [FSelectionTableElement] in
                let (all, selected) = stub
                
                return all
                    .map { symptom -> FSelectionTableElement in
                        FSelectionTableElement(id: symptom.id,
                                               name: symptom.name,
                                               isSelected: selected.contains(symptom))
                    }
            }
            .observe(on: MainScheduler.asyncInstance)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeStep() -> Driver<FSelectionStep> {
        save
            .flatMapLatest { [weak self] elements -> Single<FSelectionStep> in
                guard let this = self else {
                    return .never()
                }
                
                guard !this.needPayment() else {
                    return .just(.paygate)
                }
                
                let symptoms = elements
                    .map { Symptom(id: $0.id, name: $0.name) }
                
                return this.symptomsManager
                    .rxSet(symptoms: symptoms)
                    .map { .saved }
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func needPayment() -> Bool {
        let config = monetizationManager.getMonetizationConfig()?.symptoms ?? false
        let hasActiveSubscription = sessionManager.getSession()?.activeSubscription ?? false
        
        if hasActiveSubscription {
            return false
        }
        
        return config
    }
}
