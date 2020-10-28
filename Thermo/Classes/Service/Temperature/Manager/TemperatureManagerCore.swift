//
//  TemperatureManagerCore.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.10.2020.
//

import RxSwift

final class TemperatureManagerCore: TemperatureManager {
    struct Constants {
        static let cachedTemperaturesKey = "temperature_manager_core_cached_temperatures_key"
    }
}

// MARK: API
extension TemperatureManagerCore {
    func log(member: Member, value: Double, unit: TemperatureUnit, overallFeeling: OverallFeeling) -> Temperature? {
        let temperature = Temperature(id: Int.random(in: 0..<Int.max),
                                      member: member,
                                      value: value,
                                      unit: unit,
                                      overallFeeling: overallFeeling,
                                      date: Date())
        
        var temperatures = getAllTemperatures()
        temperatures.append(temperature)
        
        guard store(temperatures: temperatures) else {
            return nil
        }
        
        TemperatureManagerMediator.shared.notifyAboutLogged(temperature: temperature)
        
        return temperature
    }
    
    func remove(temperatureId: Int) {
        var temperatures = getAllTemperatures()
        temperatures.removeAll(where: { $0.id == temperatureId })
        
        store(temperatures: temperatures)
        
        TemperatureManagerMediator.shared.notifyAboutRemoved(temperatureId: temperatureId)
    }
    
    func remove(memberId: Int) {
        var temperatures = getAllTemperatures()
        temperatures.removeAll(where: { $0.member.id == memberId })
        
        store(temperatures: temperatures)
        
        TemperatureManagerMediator.shared.notifyAboutRemovedAll(for: memberId)
    }
    
    func get(for memberId: Int) -> [Temperature] {
        getAllTemperatures()
            .filter { $0.member.id == memberId }
    }
    
    func get(temperatureId: Int) -> Temperature? {
        getAllTemperatures()
            .first(where: { $0.id == temperatureId })
    }
}

// MARK: API(Rx)
extension TemperatureManagerCore {
    func rxLog(member: Member, value: Double, unit: TemperatureUnit, overallFeeling: OverallFeeling) -> Single<Temperature?> {
        Single<Temperature?>
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                event(.success(this.log(member: member, value: value, unit: unit, overallFeeling: overallFeeling)))
                
                return Disposables.create()
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.asyncInstance)
    }
    
    func rxRemove(temperatureId: Int) -> Completable {
        Completable
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                this.remove(temperatureId: temperatureId)
                
                event(.completed)
                
                return Disposables.create()
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.asyncInstance)
    }
    
    func rxRemove(memberId: Int) -> Completable {
        Completable
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                this.remove(memberId: memberId)
                
                event(.completed)
                
                return Disposables.create()
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.asyncInstance)
    }
    
    func rxGet(for memberId: Int) -> Single<[Temperature]> {
        Single<[Temperature]>
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                event(.success(this.get(for: memberId)))
                
                return Disposables.create()
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.asyncInstance)
    }
    
    func rxGet(temperatureId: Int) -> Single<Temperature?> {
        Single<Temperature?>
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                event(.success(this.get(temperatureId: temperatureId)))
                
                return Disposables.create()
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.asyncInstance)
    }
}

// MARK: Private
private extension TemperatureManagerCore {
    @discardableResult
    func store(temperatures: [Temperature]) -> Bool {
        guard let data = try? JSONEncoder().encode(temperatures) else {
            return false
        }
        
        UserDefaults.standard.setValue(data, forKeyPath: Constants.cachedTemperaturesKey)
        
        return true
    }
    
    func getAllTemperatures() -> [Temperature] {
        guard
            let data = UserDefaults.standard.data(forKey: Constants.cachedTemperaturesKey),
            let temperatures = try? JSONDecoder().decode([Temperature].self, from: data)
        else {
            return []
        }
        
        return temperatures
    }
}
