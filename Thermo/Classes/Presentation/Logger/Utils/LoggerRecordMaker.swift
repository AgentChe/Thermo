//
//  LoggerRecordMaker.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 29.11.2020.
//

import RxSwift
import RxCocoa

final class LoggerRecordMaker {
    private let selectTemperatureValue: PublishRelay<Double>
    private let selectTemperatureUnit: PublishRelay<TemperatureUnit>
    private let selectOverallFeeling: BehaviorRelay<OverallFeeling>
    private let selectSymptoms: BehaviorRelay<[Symptom]>
    private let selectMedicines: BehaviorRelay<[Medicine]>
    
    private let membersManager: MembersManagerCore
    private let recordManager: RecordManagerCore
    
    private let needPayment: Observable<Bool>
    
    private let create: PublishRelay<Void>
    
    init(selectTemperatureValue: PublishRelay<Double>,
         selectTemperatureUnit: PublishRelay<TemperatureUnit>,
         selectOverallFeeling: BehaviorRelay<OverallFeeling>,
         selectSymptoms: BehaviorRelay<[Symptom]>,
         selectMedicines: BehaviorRelay<[Medicine]>,
         membersManager: MembersManagerCore,
         recordManager: RecordManagerCore,
         needPayment: Observable<Bool>,
         create: PublishRelay<Void>) {
        self.selectTemperatureValue = selectTemperatureValue
        self.selectTemperatureUnit = selectTemperatureUnit
        self.selectOverallFeeling = selectOverallFeeling
        self.selectSymptoms = selectSymptoms
        self.selectMedicines = selectMedicines
        
        self.membersManager = membersManager
        self.recordManager = recordManager
        
        self.needPayment = needPayment
        
        self.create = create
    }
}

// MARK: API
extension LoggerRecordMaker {
    func makeRecord() -> Driver<LoggerViewModel.Step> {
        membersManager
            .rxCurrentMember()
            .asDriver(onErrorJustReturn: nil)
            .flatMap { [weak self] currentMember -> Driver<LoggerViewModel.Step> in
                guard let this = self else {
                    return .empty()
                }
                
                guard let member = currentMember else {
                    return .just(.error("TemperatureLogger.Log.Failure".localized))
                }
                
                return this.makeRecord(currentMember: member)
            }
    }
}

// MARK: Private
private extension LoggerRecordMaker {
    func makeRecord(currentMember: Member) -> Driver<LoggerViewModel.Step> {
        switch currentMember.unit {
        case .me, .child, .parent, .other:
            return makeHumanStep(currentMember: currentMember)
        case .animal:
            return makeAnimalStep(currentMember: currentMember)
        case .object:
            return makeObjectStep(currentMember: currentMember)
        }
    }

    func makeHumanStep(currentMember: Member) -> Driver<LoggerViewModel.Step> {
        let attributions = Observable.combineLatest(
            selectTemperatureValue.asObservable(),
            selectTemperatureUnit.asObservable(),
            selectOverallFeeling.asObservable(),
            selectSymptoms.asObservable(),
            selectMedicines.asObservable()
        )
        
        let stub = Observable.combineLatest(
            needPayment,
            attributions
        )
        
        return create
            .withLatestFrom(stub)
            .flatMapLatest { [weak self] stub -> Single<LoggerViewModel.Step> in
                guard let this = self else {
                    return .never()
                }
                
                let (needPayment, attributions) = stub
                
                guard !needPayment else {
                    return .just(.paygate)
                }
                
                let (temperatureValue,
                     temperatureUnit,
                     overallFeeling,
                     symptoms,
                     medicines) = attributions
                
                let temperature = Temperature(value: temperatureValue, unit: temperatureUnit)
                
                return this.recordManager
                    .rxLog(human: currentMember,
                           temperature: temperature,
                           overallFeeling: overallFeeling,
                           symptoms: symptoms,
                           medicines: medicines)
                    .catchErrorJustReturn(nil)
                    .map { humanRecord -> LoggerViewModel.Step in
                        if let value = humanRecord {
                            return .logged(value)
                        } else {
                            return .error("TemperatureLogger.Log.Failure".localized)
                        }
                    }
            }
            .asDriver(onErrorJustReturn: .error("TemperatureLogger.Log.Failure".localized))
    }
    
    func makeAnimalStep(currentMember: Member) -> Driver<LoggerViewModel.Step> {
        let attributions = Observable.combineLatest(
            selectTemperatureValue.asObservable(),
            selectTemperatureUnit.asObservable()
        )
        
        let stub = Observable.combineLatest(
            needPayment,
            attributions
        )
        
        return create
            .withLatestFrom(stub)
            .flatMapLatest { [weak self] stub -> Single<LoggerViewModel.Step> in
                guard let this = self else {
                    return .never()
                }
                
                let (needPayment, attributions) = stub
                
                guard !needPayment else {
                    return .just(.paygate)
                }
                
                let (temperatureValue,
                     temperatureUnit) = attributions
                
                let temperature = Temperature(value: temperatureValue, unit: temperatureUnit)
                
                return this.recordManager
                    .rxLog(animal: currentMember,
                           temperature: temperature)
                    .catchErrorJustReturn(nil)
                    .map { animalRecord -> LoggerViewModel.Step in
                        if let value = animalRecord {
                            return .logged(value)
                        } else {
                            return .error("TemperatureLogger.Log.Failure".localized)
                        }
                    }
            }
            .asDriver(onErrorJustReturn: .error("TemperatureLogger.Log.Failure".localized))
    }
    
    func makeObjectStep(currentMember: Member) -> Driver<LoggerViewModel.Step> {
        let attributions = Observable.combineLatest(
            selectTemperatureValue.asObservable(),
            selectTemperatureUnit.asObservable()
        )
        
        let stub = Observable.combineLatest(
            needPayment,
            attributions
        )
        
        return create
            .withLatestFrom(stub)
            .flatMapLatest { [weak self] stub -> Single<LoggerViewModel.Step> in
                guard let this = self else {
                    return .never()
                }
                
                let (needPayment, attributions) = stub
                
                guard !needPayment else {
                    return .just(.paygate)
                }
                
                let (temperatureValue,
                     temperatureUnit) = attributions
                
                let temperature = Temperature(value: temperatureValue, unit: temperatureUnit)
                
                return this.recordManager
                    .rxLog(object: currentMember,
                           temperature: temperature)
                    .catchErrorJustReturn(nil)
                    .map { objectRecord -> LoggerViewModel.Step in
                        if let value = objectRecord {
                            return .logged(value)
                        } else {
                            return .error("TemperatureLogger.Log.Failure".localized)
                        }
                    }
            }
            .asDriver(onErrorJustReturn: .error("TemperatureLogger.Log.Failure".localized))
    }
}
