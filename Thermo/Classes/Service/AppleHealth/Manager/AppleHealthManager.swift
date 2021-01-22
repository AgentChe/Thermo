//
//  AppleHealthManager.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 22.01.2021.
//

import RxSwift

protocol AppleHealthManager {
    // MARK: API(Rx)
    func obtainTemperature(for unit: TemperatureUnit) -> Single<Temperature?>
}
