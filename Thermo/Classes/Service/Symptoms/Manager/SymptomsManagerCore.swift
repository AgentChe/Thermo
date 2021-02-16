//
//  SymptomsManagerCore.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 21.11.2020.
//

import RxSwift

final class SymptomsManagerCore: SymptomsManager {
    struct Constants {
        static let symptomsCachedKey = "symptoms_manager_core_symptoms_cached_key"
        static let selectedSymptomsCachedKey = "symptoms_manager_core_selected_symptoms_cached_key"
        static let selectedSymptomsDateKey = "symptoms_manager_core_selected_date_key"
    }
}

// MARK: API
extension SymptomsManagerCore {
    func getSymptoms() -> [Symptom] {
        guard
            let data = UserDefaults.standard.data(forKey: Constants.symptomsCachedKey),
            let symptoms = try? JSONDecoder().decode([Symptom].self, from: data)
        else {
            return []
        }
        
        return symptoms
    }
    
    func getSelectedSymptoms() -> [Symptom] {
        guard
            let date = UserDefaults.standard.object(forKey: Constants.selectedSymptomsDateKey) as? Date,
            let selectedSymptomsData = UserDefaults.standard.data(forKey: Constants.selectedSymptomsCachedKey),
            let selectedSymptoms = try? JSONDecoder().decode([Symptom].self, from: selectedSymptomsData)
        else {
            return []
        }
        
        guard Calendar.current.isDateInToday(date) else {
            return []
        }
        
        return selectedSymptoms
    }
    
    func set(symptoms: [Symptom]) {
        guard let data = try? JSONEncoder().encode(symptoms) else {
            return
        }
        
        UserDefaults.standard.setValue(data, forKey: Constants.selectedSymptomsCachedKey)
        UserDefaults.standard.setValue(Date(), forKey: Constants.selectedSymptomsDateKey)
    }
}

// MARK: API(Rx)
extension SymptomsManagerCore {
    func rxRetrieveSymptoms(forceUpdate: Bool) -> Single<[Symptom]> {
        if forceUpdate {
            return loadSymptoms()
        } else {
            return .deferred { [weak self] in
                guard let this = self else {
                    return .never()
                }
                
                return Single.just(this.getSymptoms())
                    .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
                    .observe(on: MainScheduler.asyncInstance)
            }
        }
    }
    
    func rxGetSelectedSymptoms() -> Single<[Symptom]> {
        Single<[Symptom]>
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                let symptoms = this.getSelectedSymptoms()
                
                event(.success(symptoms))
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
    }
    
    func rxSet(symptoms: [Symptom]) -> Single<Void> {
        Single<Void>
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                this.set(symptoms: symptoms)
                
                event(.success(Void()))
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
    }
}

// MARK: Private
private extension SymptomsManagerCore {
    func loadSymptoms() -> Single<[Symptom]> {
        SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: GetSymptomsRequest())
            .map { GetSymptomsResponseMapper.map(response: $0) }
            .flatMap(store(symptoms:))
            .catchAndReturn([])
    }
    
    func store(symptoms: [Symptom]) -> Single<[Symptom]> {
        Single<[Symptom]>
            .create { event in
                guard let data = try? JSONEncoder().encode(symptoms) else {
                    event(.success(symptoms))
                    
                    return Disposables.create()
                }
                
                UserDefaults.standard.set(data, forKey: Constants.symptomsCachedKey)
                
                event(.success(symptoms))
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
    }
}
