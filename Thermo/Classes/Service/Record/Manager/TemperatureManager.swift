//
//  TemperatureManager.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.10.2020.
//

import RxSwift

protocol TemperatureManager: class {
    // MARK: API
    func log(member: Member,
             value: Double,
             unit: TemperatureUnit,
             overallFeeling: OverallFeeling,
             symptoms: [Symptom],
             medicines: [Medicine]) -> Temperature?
    func remove(temperatureId: Int)
    func remove(memberId: Int)
    func get(for memberId: Int) -> [Temperature]
    func get(temperatureId: Int) -> Temperature?
    
    // MARK: API(Rx)
    func rxLog(member: Member,
             value: Double,
             unit: TemperatureUnit,
             overallFeeling: OverallFeeling,
             symptoms: [Symptom],
             medicines: [Medicine]) -> Single<Temperature?>
    func rxRemove(temperatureId: Int) -> Completable
    func rxRemove(memberId: Int) -> Completable
    func rxGet(for memberId: Int) -> Single<[Temperature]>
    func rxGet(temperatureId: Int) -> Single<Temperature?>
}
