//
//  TemperatureManager.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.10.2020.
//

import RxSwift

protocol RecordManager: class {
    // MARK: API
    func log(human: Member,
             temperature: Temperature,
             overallFeeling: OverallFeeling,
             symptoms: [Symptom],
             medicines: [Medicine]) -> HumanRecord?
    func remove(recordId: Int)
    func remove(memberId: Int)
    func get(for memberId: Int) -> [Record]
    func get(recordId: Int) -> Record?
    
    // MARK: API(Rx)
    func rxLog(human: Member,
               temperature: Temperature,
               overallFeeling: OverallFeeling,
               symptoms: [Symptom],
               medicines: [Medicine]) -> Single<HumanRecord?>
    func rxRemove(recordId: Int) -> Completable
    func rxRemove(memberId: Int) -> Completable
    func rxGet(for memberId: Int) -> Single<[Record]>
    func rxGet(recordId: Int) -> Single<Record?>
}
