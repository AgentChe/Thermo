//
//  MembersManager.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.10.2020.
//

import RxSwift

protocol MembersManager: class {
    // MARK: API
    func store(temperatureUnit: TemperatureUnit) -> Member?
    func get() -> Member?
    
    // MARK: API(Rx)
    func rxStore(temperatureUnit: TemperatureUnit) -> Single<Member?>
    func rxGet() -> Single<Member?>
}
