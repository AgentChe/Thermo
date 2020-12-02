//
//  TreatmentsViewModel.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 02.12.2020.
//

import RxSwift
import RxCocoa

final class TreatmentsViewModel {
    let loading = RxActivityIndicator()
    
    private let treatmentsManager = TreatmentsManagerCore()
}

// MARK: API
extension TreatmentsViewModel {
    func conditions() -> Driver<[TreatmentCondition]> {
        Single
            .zip(delay(), obtain()) { $1 }
            .trackActivity(loading)
            .asDriver(onErrorJustReturn: [])
    }
}

// MARK: Private
private extension TreatmentsViewModel {
    // Задержка для отображения анимации
    func delay() -> Single<Void> {
        Single<Void>
            .create { event in
                DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 3) {
                    DispatchQueue.main.async {
                        event(.success(Void()))
                    }
                }
                
                return Disposables.create()
            }
    }
    
    // TODO: заполнить данными
    func obtain() -> Single<[TreatmentCondition]> {
        treatmentsManager
            .rxObtainConditions(gender: "", age: 1, symptomsIds: [], medicinesIds: [])
            .catchErrorJustReturn([])
    }
}
