//
//  MedicineManagerCore.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 21.11.2020.
//

import RxSwift

final class MedicineManagerCore: MedicineManager {
    struct Constraints {
        static let medicinesCachedKey = "medicines_manager_core_medicines_cached_key"
    }
}

// MARK: API
extension MedicineManagerCore {
    func getMedicines() -> [Medicine] {
        guard
            let data = UserDefaults.standard.data(forKey: Constraints.medicinesCachedKey),
            let medicines = try? JSONDecoder().decode([Medicine].self, from: data)
        else {
            return []
        }
        
        return medicines
    }
}

// MARK: API(Rx)
extension MedicineManagerCore {
    func rxRetrieveMedicines(forceUpdate: Bool) -> Single<[Medicine]> {
        if forceUpdate {
            return loadMedicines()
        } else {
            return .deferred { [weak self] in
                guard let this = self else {
                    return .never()
                }
                
                return Single.just(this.getMedicines())
                    .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
                    .observe(on: MainScheduler.asyncInstance)
            }
        }
    }
}

// MARK: Private
private extension MedicineManagerCore {
    func loadMedicines() -> Single<[Medicine]> {
        SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: GetMedicinesRequest())
            .map { GetMedicinesResponseMapper.map(response: $0) }
            .flatMap(store(medicines:))
            .catchAndReturn([])
    }
    
    func store(medicines: [Medicine]) -> Single<[Medicine]> {
        Single<[Medicine]>
            .create { event in
                guard let data = try? JSONEncoder().encode(medicines) else {
                    event(.success(medicines))
                    
                    return Disposables.create()
                }
                
                UserDefaults.standard.set(data, forKey: Constraints.medicinesCachedKey)
                
                event(.success(medicines))
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
    }
}
