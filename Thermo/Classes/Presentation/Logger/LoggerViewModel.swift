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
    
    let selectTemperature = PublishRelay<(Double, TemperatureUnit)>()
    let selectOverallFeeling = PublishRelay<OverallFeeling>()
    
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
        Observable
            .combineLatest(
                selectTemperature.asObservable(),
                selectOverallFeeling.asObservable(),
                membersManager.rxCurrentMember().asObservable()
            )
            .flatMapLatest { [weak self] stub, overallFeeling, currentMember -> Single<Step> in
                guard let this = self else {
                    return .never()
                }
                
                guard let member = currentMember else {
                    return .just(.error("TemperatureLogger.Log.Failure".localized))
                }
                
                let (temperature, unit) = stub
                
                return this.temperatureManager
                    .rxLog(member: member,
                           value: temperature,
                           unit: unit,
                           overallFeeling: overallFeeling)
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
