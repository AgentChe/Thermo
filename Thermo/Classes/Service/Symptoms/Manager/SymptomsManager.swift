//
//  SymptomsManager.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 21.11.2020.
//

import RxSwift

protocol SymptomsManager: class {
    // MARK: API
    func getSymptoms() -> [Symptom]
    func getSelectedSymptoms() -> [Symptom]
    func set(symptoms: [Symptom])
    
    // MARK: API(Rx)
    func rxRetrieveSymptoms(forceUpdate: Bool) -> Single<[Symptom]>
    func rxGetSelectedSymptoms() -> Single<[Symptom]>
    func rxSet(symptoms: [Symptom]) -> Single<Void>
}
