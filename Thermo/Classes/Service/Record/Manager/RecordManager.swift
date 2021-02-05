//
//  TemperatureManager.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.10.2020.
//

import RxSwift

protocol RecordManager: class {
    // MARK: API
    func log(temperature: Temperature,
             feeling: Feeling,
             medicines: [Medicine],
             symptoms: [Symptom]) -> Record?
    func getRecords() -> [Record]
    
    // MARK: API(Rx)
    func rxLog(temperature: Temperature,
               feeling: Feeling,
               medicines: [Medicine],
               symptoms: [Symptom]) -> Single<Record?>
    func rxGetRecords() -> Single<[Record]>
}
