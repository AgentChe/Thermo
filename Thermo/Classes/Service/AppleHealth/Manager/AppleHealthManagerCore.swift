//
//  AppleHealthManagerCore.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 22.01.2021.
//

import HealthKit
import RxSwift

final class AppleHealthManagerCore: AppleHealthManager {
    private lazy var kit = HKHealthStore()
    
    private lazy var queryType = HKQuantityType.quantityType(forIdentifier: .bodyTemperature)
    private lazy var querySample = HKSampleType.quantityType(forIdentifier: .bodyTemperature)
}

// MARK: API(Rx)
extension AppleHealthManagerCore {
    func obtainTemperature(for unit: TemperatureUnit) -> Single<Temperature?> {
        Single<Temperature?>.create { [weak self] event in
            guard let this = self else {
                return Disposables.create()
            }
            
            guard HKHealthStore.isHealthDataAvailable() else {
                event(.failure(AppleHealthError(.notAvailable)))
                
                return Disposables.create()
            }
            
            guard
                let queryType = this.queryType,
                let querySample = this.querySample
            else {
                event(.failure(AppleHealthError(.notAvailable)))
                
                return Disposables.create()
            }
            
            this.kit.requestAuthorization(toShare: [queryType],
                                          read: [querySample]) { success, error in
                guard success else {
                    event(.failure(AppleHealthError(.notAvailable, underlyingError: error)))
                    
                    return
                }
                
                let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
                
                let query = HKSampleQuery(sampleType: querySample,
                                          predicate: nil,
                                          limit: 10,
                                          sortDescriptors: [sortDescriptor]) { query, results, error in
                    let samples = results?.compactMap { $0 as? HKQuantitySample } ?? []
                    
                    guard let lastSample = samples.first else {
                        event(.success(nil))
                        
                        return
                    }
                    
                    let value: Double
                    switch unit {
                    case .celsius:
                        value = lastSample.quantity.doubleValue(for: .degreeCelsius())
                    case .fahrenheit:
                        value = lastSample.quantity.doubleValue(for: .degreeFahrenheit())
                    }
                    
                    let temperature = Temperature(value: value,
                                                  unit: unit)
                    
                    event(.success(temperature))
                }
                                            
                this.kit.execute(query)
            }
            
            return Disposables.create()
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        .observe(on: MainScheduler.asyncInstance)
    }
}
