//
//  LoggerViewModel.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import RxSwift
import RxCocoa

final class LoggerViewModel {
    enum Step {
        case logged(Temperature)
        case error(String)
    }
    
    let selectTemperatureValue = PublishRelay<Double>()
    let selectTemperatureUnit = PublishRelay<TemperatureUnit>()
    let selectOverallFeeling = PublishRelay<OverallFeeling>()
    let selectSymptoms = PublishRelay<[Symptom]>()
    let selectMedicines = PublishRelay<[Medicine]>()
    
    let create = PublishRelay<Void>()
    
    private let membersManager = MembersManagerCore()
    private let temperatureManager = TemperatureManagerCore()
    
    func temperatureRange() -> Driver<TemperatureRange> {
        membersManager
            .rxCurrentMember()
            .map { currentMember -> TemperatureRange in
                TemperatureRange(unit: currentMember?.temperatureUnit ?? .celsius)
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func step() -> Driver<Step> {
        let stub = Observable
            .combineLatest(
                selectTemperatureValue.asObservable(),
                selectTemperatureUnit.asObservable(),
                selectOverallFeeling.asObservable(),
                selectSymptoms.asObservable().startWith([]),
                selectMedicines.asObservable().startWith([]),
                membersManager.rxCurrentMember().asObservable()
            )
            
        return create
            .withLatestFrom(stub)
            .flatMapLatest { [weak self] stub -> Single<Step> in
                guard let this = self else {
                    return .never()
                }
                
                let (temperatureValue,
                     temperatureUnit,
                     overallFeeling,
                     symptoms,
                     medicines,
                     currentMember) = stub
                
                guard let member = currentMember else {
                    return .just(.error("TemperatureLogger.Log.Failure".localized))
                }
                
                return this.temperatureManager
                    .rxLog(member: member,
                           value: temperatureValue,
                           unit: temperatureUnit,
                           overallFeeling: overallFeeling,
                           symptoms: symptoms,
                           medicines: medicines)
                    .catchErrorJustReturn(nil)
                    .map { temperature -> Step in
                        if let value = temperature {
                            return .logged(value)
                        } else {
                            return .error("TemperatureLogger.Log.Failure".localized)
                        }
                    }
            }
            .asDriver(onErrorDriveWith: .empty())
    }
}
