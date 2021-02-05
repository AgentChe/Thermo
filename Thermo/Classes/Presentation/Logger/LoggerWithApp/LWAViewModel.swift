//
//  LWAViewModel.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 05.02.2021.
//

import RxSwift
import RxCocoa

// TODO: Виталь, по сути вся vm готова, тебе ее не нужно трогать совсем. Просто во vc дерни create.accept(pulse) и все. Остальное все готово.
final class LWAViewModel {
    enum Step {
        case created, error
    }
    
    lazy var create = PublishRelay<Double>()
    
    private lazy var medicinesManager = MedicineManagerCore()
    private lazy var symptomsManager = SymptomsManagerCore()
    private lazy var feelingManager = FeelingManagerCore()
    private lazy var recordManager = RecordManagerCore()
    private lazy var memberManager = MembersManagerCore()
    
    lazy var step = makeStep()
}

// MARK: Private
private extension LWAViewModel {
    func makeStep() -> Driver<Step> {
        create
            .flatMapLatest { [weak self] temperature -> Single<Step> in
                guard let this = self else {
                    return .never()
                }
                
                let symptoms = this.symptomsManager.getSelectedSymptoms()
                let medicines = this.medicinesManager.getMedicines()
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
}
