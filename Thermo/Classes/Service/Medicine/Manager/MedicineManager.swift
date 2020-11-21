//
//  MedicineManager.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 21.11.2020.
//

import RxSwift

protocol MedicineManager: class {
    // MARK: API
    func getMedicines() -> [Medicine]
    
    // MARK: API(Rx)
    func rxRetrieveMedicines(forceUpdate: Bool) -> Single<[Medicine]>
}
