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
    
    lazy var elements = makeElements()
    lazy var saved = makeSaved()
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
    
    func makeSaved() -> Driver<Void> {
        save
            .flatMapLatest { [weak self] elements -> Single<Void> in
                guard let this = self else {
                    return .never()
                }
                
                let symptoms = elements
                    .map { Symptom(id: $0.id, name: $0.name) }
                
                return this.symptomsManager
                    .rxSet(symptoms: symptoms)
            }
            .asDriver(onErrorDriveWith: .empty())
    }
}
