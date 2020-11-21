//
//  TemperatureManagerMediator.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import RxSwift
import RxCocoa

final class TemperatureManagerMediator {
    static let shared = TemperatureManagerMediator()
    
    private let loggedTrigger = PublishRelay<Temperature>()
    private let removedTrigger = PublishRelay<Int>()
    private let removedAllForMemberTrigger = PublishRelay<Int>()
    
    private var delegates = [Weak<TemperatureManagerMediatorDelegate>]()
    
    private init() {}
}

// MARK: API
extension TemperatureManagerMediator {
    func notifyAboutLogged(temperature: Temperature) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.temperatureManagerMediatorDidLogged(temperature: temperature)
            }
            
            self?.loggedTrigger.accept(temperature)
        }
    }
    
    func notifyAboutRemoved(temperatureId: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.temperatureManagerMediatorDidRemoved(temperatureId: temperatureId)
            }
            
            self?.removedTrigger.accept(temperatureId)
        }
    }
    
    func notifyAboutRemovedAll(for memberId: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.temperatureManagerMediatorDidRemovedAll(for: memberId)
            }
            
            self?.removedAllForMemberTrigger.accept(memberId)
        }
    }
}

// MARK: Triggers(Rx)
extension TemperatureManagerMediator {
    var rxDidLoggedTemperature: Signal<Temperature> {
        loggedTrigger.asSignal()
    }
    
    var rxDidRemovedTemperatureId: Signal<Int> {
        removedTrigger.asSignal()
    }
    
    var rxDidRemovedAllTemperaturesForMember: Signal<Int> {
        removedAllForMemberTrigger.asSignal()
    }
}

// MARK: Observer
extension TemperatureManagerMediator {
    func add(delegate: TemperatureManagerMediatorDelegate) {
        let weakly = delegate as AnyObject
        delegates.append(Weak<TemperatureManagerMediatorDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }

    func remove(delegate: TemperatureManagerMediatorDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === delegate }) {
            delegates.remove(at: index)
        }
    }
}
