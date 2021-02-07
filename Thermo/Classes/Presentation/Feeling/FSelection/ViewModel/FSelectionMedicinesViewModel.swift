//
//  FSelectionMedicinesViewModel.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 07.02.2021.
//

import RxSwift
import RxCocoa

final class FSelectionMedicinesViewModel: FSelectionViewModel {
    lazy var save = PublishRelay<[FSelectionTableElement]>()
    
    private lazy var medicinesManager = MedicineManagerCore()
    
    lazy var elements = makeElements()
    lazy var saved = makeSaved()
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
    
    func makeSaved() -> Driver<Void> {
        save
            .flatMapLatest { [weak self] elements -> Single<Void> in
                guard let this = self else {
                    return .never()
                }
                
                let medicines = elements
                    .map { Medicine(id: $0.id, name: $0.name) }
                
                return this.medicinesManager
                    .rxSet(medicines: medicines)
            }
            .asDriver(onErrorDriveWith: .empty())
    }
}
