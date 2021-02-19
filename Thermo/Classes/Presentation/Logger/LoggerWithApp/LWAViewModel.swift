//
//  LWAViewModel.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 05.02.2021.
//

import RxSwift
import RxCocoa

final class LWAViewModel {
    enum Step {
        case created, error
    }
    
    lazy var create = PublishRelay<Double>()
    lazy var pulse = PublishRelay<Double>()
    
    private lazy var medicinesManager = MedicineManagerCore()
    private lazy var symptomsManager = SymptomsManagerCore()
    private lazy var feelingManager = FeelingManagerCore()
    private lazy var recordManager = RecordManagerCore()
    private lazy var memberManager = MembersManagerCore()
    
    lazy var step = makeStep()
    lazy var temperature = makeTemperature()
    lazy var lwaResult = makeLWAResult()
    lazy var currentTemperatureUnit = makeCurrentTemperatureUnit()
}

// MARK: Private
private extension LWAViewModel {
    func makeCurrentTemperatureUnit() -> Driver<TemperatureUnit> {
        memberManager
            .rxGet()
            .compactMap { $0 }
            .map { $0.temperatureUnit }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeStep() -> Driver<Step> {
        create
            .flatMapLatest { [weak self] temperature -> Single<Step> in
                guard let this = self else {
                    return .never()
                }
                
                let symptoms = this.symptomsManager.getSelectedSymptoms()
                let medicines = this.medicinesManager.getSelectedMedicines()
                let feeling = this.feelingManager.getSelected()
                let unit = this.memberManager.get()?.temperatureUnit ?? .celsius
                
                let temperature = Temperature(value: temperature, unit: unit)
                
                return this.recordManager
                    .rxLog(temperature: temperature,
                           feeling: feeling,
                           medicines: medicines,
                           symptoms: symptoms)
                    .map { record -> Step in
                        record == nil ? .error : .created
                    }
            }
            .asDriver(onErrorJustReturn: .error)
    }
    
    func makeTemperature() -> Driver<Double> {
        pulse
            .map { [weak self] pulse -> Double in
                guard let unit = self?.memberManager.get()?.temperatureUnit else {
                    return 0
                }
                
                return PulseToTemperature.calculate(pulse: pulse, unit: unit)
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeLWAResult() -> Driver<LWAResultElement> {
        temperature
            .withLatestFrom(currentTemperatureUnit) { ($0, $1) }
            .map { [weak self] stub in
                let (temperature, unit) = stub
                
                let limit: Double
                switch unit {
                case .celsius:
                    limit = 37.2
                case .fahrenheit:
                    limit = 98.96
                }
                
                return LWAResultElement(
                    min: temperature - 0.2,
                    max: temperature + 0.2,
                    isSuccess: temperature < limit,
                    unit: self?.memberManager.get()?.temperatureUnit ?? .celsius
                )
        }
    }
}
