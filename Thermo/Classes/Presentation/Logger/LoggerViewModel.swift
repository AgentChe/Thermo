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
        case logged(Record)
        case error(String)
        case paygate
    }
    
    let selectTemperatureValue = PublishRelay<Double>()
    let selectTemperatureUnit = PublishRelay<TemperatureUnit>()
    let selectOverallFeeling = BehaviorRelay<OverallFeeling>(value: .recovered)
    let selectSymptoms = BehaviorRelay<[Symptom]>(value: [])
    let selectMedicines = BehaviorRelay<[Medicine]>(value: [])
    
    let create = PublishRelay<Void>()
    
    private let membersManager = MembersManagerCore()
    private let recordManager = RecordManagerCore()
    private let sessionManager = SessionManagerCore()
    private let medicineManager = MedicineManagerCore()
    private let symptomsManager = SymptomsManagerCore()
    private let monetizationManager = MonetizationManagerCore()
    
    private lazy var recordMaker = LoggerRecordMaker(selectTemperatureValue: selectTemperatureValue,
                                                     selectTemperatureUnit: selectTemperatureUnit,
                                                     selectOverallFeeling: selectOverallFeeling,
                                                     selectSymptoms: selectSymptoms,
                                                     selectMedicines: selectMedicines,
                                                     membersManager: membersManager,
                                                     recordManager: recordManager,
                                                     needPayment: needPayment(),
                                                     create: create)
    
    func symptoms() -> Driver<[Symptom]> {
        symptomsManager
            .rxRetrieveSymptoms(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func medicines() -> Driver<[Medicine]> {
        medicineManager
            .rxRetrieveMedicines(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func hasActiveSubscription() -> Bool {
        sessionManager.getSession()?.activeSubscription ?? false
    }
    
    func temperatureRange() -> Driver<TemperatureRange> {
        makeTemperatureRange()
    }
    
    func currentMember() -> Driver<Member> {
        membersManager
            .rxCurrentMember()
            .asDriver(onErrorJustReturn: nil)
            .compactMap { $0 }
    }
    
    func step() -> Driver<Step> {
        recordMaker.makeRecord()
    }
}

// MARK: Private
private extension LoggerViewModel {
    func makeTemperatureRange() -> Driver<TemperatureRange> {
        membersManager
            .rxCurrentMember()
            .compactMap { $0 }
            .map { TemperatureRange(for: $0) }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func needPayment() -> Observable<Bool> {
        let recordsCount = membersManager
            .rxCurrentMember()
            .flatMap { [weak self] currentMember -> Single<Int> in
                guard let this = self, let member = currentMember else {
                    return .just(0)
                }
                
                return this.recordManager
                    .rxGet(for: member.id)
                    .map { $0.count }
            }
            .catchErrorJustReturn(0)
            .asObservable()
        
        let config = monetizationManager
            .rxRetrieveMonetizationConfig(forceUpdate: false)
            .catchErrorJustReturn(nil)
            .asObservable()
        
        let initial = Observable<Bool>.deferred { [weak self] in
            guard let this = self else {
                return .empty()
            }
            
            let activeSubscription = this.sessionManager.getSession()?.activeSubscription ?? false
            
            return .just(activeSubscription)
        }
        
        let updated = SDKStorage.shared
            .purchaseMediator
            .rxPurchaseMediatorDidValidateReceipt
            .map { $0?.activeSubscription ?? false }
            .asObservable()
        
        let activeSubscription = Observable
            .merge(initial, updated)
        
        return Observable
            .combineLatest(recordsCount, config, activeSubscription)
            .map { recordsCount, config, activeSubscription -> Bool in
                guard let config = config else {
                    return false
                }
                
                if !config.afterTemperatureTracking {
                    return false
                }
                
                if recordsCount <= config.maxFreeTracking {
                    return false
                }
                
                return !activeSubscription
            }
    }
}
