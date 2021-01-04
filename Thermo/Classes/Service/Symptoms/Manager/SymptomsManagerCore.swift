//
//  SymptomsManagerCore.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 21.11.2020.
//

import RxSwift

final class SymptomsManagerCore: SymptomsManager {
    struct Constraints {
        static let symptomsCachedKey = "symptoms_manager_core_symptoms_cached_key"
    }
}

// MARK: API
extension SymptomsManagerCore {
    func getSymptoms() -> [Symptom] {
        guard
            let data = UserDefaults.standard.data(forKey: Constraints.symptomsCachedKey),
            let symptoms = try? JSONDecoder().decode([Symptom].self, from: data)
        else {
            return []
        }
        
        return symptoms
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
                
                UserDefaults.standard.set(data, forKey: Constraints.symptomsCachedKey)
                
                event(.success(symptoms))
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
    }
}
