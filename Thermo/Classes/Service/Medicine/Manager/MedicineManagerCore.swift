//
//  MedicineManagerCore.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 21.11.2020.
//

import RxSwift

final class MedicineManagerCore: MedicineManager {
    struct Constants {
        static let medicinesCachedKey = "medicines_manager_core_medicines_cached_key"
        static let selectedMedicinesCachedKey = "medicines_manager_core_selected_medicines_cached_key"
        static let selectedMedicinesDateKey = "medicines_manager_core_selected_date_key"
    }
}

// MARK: API
extension MedicineManagerCore {
    func getMedicines() -> [Medicine] {
        guard
            let data = UserDefaults.standard.data(forKey: Constants.medicinesCachedKey),
            let medicines = try? JSONDecoder().decode([Medicine].self, from: data)
        else {
            return []
        }
        
        return medicines
    }
    
    func getSelectedMedicines() -> [Medicine] {
        guard
            let date = UserDefaults.standard.object(forKey: Constants.selectedMedicinesDateKey) as? Date,
            let selectedMedicinesData = UserDefaults.standard.data(forKey: Constants.selectedMedicinesCachedKey),
            let selectedMedicines = try? JSONDecoder().decode([Medicine].self, from: selectedMedicinesData)
        else {
            return []
        }
        
        guard Calendar.current.isDateInToday(date) else {
            return []
        }
        
        return selectedMedicines
    }
    
    func set(medicines: [Medicine]) {
        guard let data = try? JSONEncoder().encode(medicines) else {
            return
        }
        
        UserDefaults.standard.setValue(data, forKey: Constants.selectedMedicinesCachedKey)
        UserDefaults.standard.setValue(Date(), forKey: Constants.selectedMedicinesDateKey)
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
    
    func rxGetSelectedMedicines() -> Single<[Medicine]> {
        Single<[Medicine]>
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                let medicines = this.getSelectedMedicines()
                
                event(.success(medicines))
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
    }
    
    func rxSet(medicines: [Medicine]) -> Single<Void> {
        Single<Void>
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                this.set(medicines: medicines)
                
                event(.success(Void()))
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
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
                
                UserDefaults.standard.set(data, forKey: Constants.medicinesCachedKey)
                
                event(.success(medicines))
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
    }
}
