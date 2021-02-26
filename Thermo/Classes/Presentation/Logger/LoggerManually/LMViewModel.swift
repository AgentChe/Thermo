//
//  LMViewModel.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 08.02.2021.
//

import RxSwift
import RxCocoa

final class LMViewModel {
    enum Step {
        case created(showPaygate: Bool)
        case error
        case paygate
    }
    
    lazy var create = PublishRelay<Double>()
    
    private lazy var medicinesManager = MedicineManagerCore()
    private lazy var symptomsManager = SymptomsManagerCore()
    private lazy var feelingManager = FeelingManagerCore()
    private lazy var recordManager = RecordManagerCore()
    private lazy var membersManager = MembersManagerCore()
    private lazy var sessionManager = SessionManagerCore()
    private lazy var monetizationManager = MonetizationManagerCore()
    
    lazy var temperatureRange = makeTemperatureRange()
    lazy var step = makeStep()
}

// MARK: Private
private extension LMViewModel {
    func makeStep() -> Driver<Step> {
        create
            .flatMapLatest { [weak self] temperature -> Single<Step> in
                guard let this = self else {
                    return .never()
                }
                
                guard !this.needPaymentBeforeTemperatureLog() else {
                    return .just(.paygate)
                }
                
                let symptoms = this.symptomsManager.getSelectedSymptoms()
                let medicines = this.medicinesManager.getSelectedMedicines()
                let feeling = this.feelingManager.getSelected()
                let unit = this.membersManager.get()?.temperatureUnit ?? .celsius
                
                let temperature = Temperature(value: temperature, unit: unit)
                
                return this.recordManager
                    .rxLog(temperature: temperature,
                           feeling: feeling,
                           medicines: medicines,
                           symptoms: symptoms)
                    .map { record -> Step in
                        record == nil ? .error : .created(showPaygate: this.needPaymentAfterTemperatureLog())
                    }
            }
            .asDriver(onErrorJustReturn: .error)
    }
    
    func makeTemperatureRange() -> Driver<TemperatureRange> {
        membersManager
            .rxGet()
            .compactMap { $0 }
            .map { TemperatureRange(for: $0.temperatureUnit) }
            .asDriver(onErrorDriveWith: .empty())
    }
}

// MARK: Private(Need payment)
private extension LMViewModel {
    func needPaymentBeforeTemperatureLog() -> Bool {
        let config = monetizationManager.getMonetizationConfig()?.temperature ?? false
        return needPayment(for: config)
    }
    
    func needPaymentAfterTemperatureLog() -> Bool {
        let config = monetizationManager.getMonetizationConfig()?.afterTemperatureTracking ?? false
        return needPayment(for: config)
    }
    
    func needPayment(for config: Bool) -> Bool {
        let hasActiveSubscription = sessionManager.getSession()?.activeSubscription ?? false
        
        if hasActiveSubscription {
            return false
        }
        
        return config
    }
}
