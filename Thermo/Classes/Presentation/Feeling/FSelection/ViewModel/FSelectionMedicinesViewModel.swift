//
//  FSelectionMedicinesViewModel.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 07.02.2021.
//

import RxSwift
import RxCocoa

final class FSelectionMedicinesViewModel: FSelectionViewModel {
    enum Step {
        case saved, paygate
    }
    
    lazy var save = PublishRelay<[FSelectionTableElement]>()
    
    private lazy var medicinesManager = MedicineManagerCore()
    private lazy var sessionManager = SessionManagerCore()
    private lazy var monetizationManager = MonetizationManagerCore()
    
    lazy var elements = makeElements()
    lazy var step = makeStep()
}

// MARK: Private
private extension FSelectionMedicinesViewModel {
    func makeElements() -> Driver<[FSelectionTableElement]> {
        let all = medicinesManager
            .rxRetrieveMedicines(forceUpdate: false)
        
        let selected = medicinesManager
            .rxGetSelectedMedicines()
        
        return Single
            .zip(all, selected)
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .map { stub -> [FSelectionTableElement] in
                let (all, selected) = stub
                
                return all
                    .map { medicine -> FSelectionTableElement in
                        FSelectionTableElement(id: medicine.id,
                                               name: medicine.name,
                                               isSelected: selected.contains(medicine))
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
                
                let medicines = elements
                    .map { Medicine(id: $0.id, name: $0.name) }
                
                return this.medicinesManager
                    .rxSet(medicines: medicines)
                    .map { .saved }
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func needPayment() -> Bool {
        let config = monetizationManager.getMonetizationConfig()?.medicines ?? false
        let hasActiveSubscription = sessionManager.getSession()?.activeSubscription ?? false
        
        if hasActiveSubscription {
            return false
        }
        
        return config
    }
}
