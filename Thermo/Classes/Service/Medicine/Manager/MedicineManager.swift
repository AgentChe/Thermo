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
    func getSelectedMedicines() -> [Medicine]
    func set(medicines: [Medicine])
    
    // MARK: API(Rx)
    func rxRetrieveMedicines(forceUpdate: Bool) -> Single<[Medicine]>
    func rxGetSelectedMedicines() -> Single<[Medicine]>
    func rxSet(medicines: [Medicine]) -> Single<Void>
}
