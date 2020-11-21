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
    
    // MARK: API(Rx)
    func rxRetrieveSymptoms(forceUpdate: Bool) -> Single<[Symptom]>
}
