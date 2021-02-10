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
        case created, error
    }
    
    lazy var create = PublishRelay<Double>()
    
    private lazy var medicinesManager = MedicineManagerCore()
    private lazy var symptomsManager = SymptomsManagerCore()
    private lazy var feelingManager = FeelingManagerCore()
    private lazy var recordManager = RecordManagerCore()
    private lazy var membersManager = MembersManagerCore()
    
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
                        record == nil ? .error : .created
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
