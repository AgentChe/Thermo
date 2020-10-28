//
//  TemperatureManagerMediatorDelegate.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

protocol TemperatureManagerMediatorDelegate: class {
    func temperatureManagerMediatorDidLogged(temperature: Temperature)
    func temperatureManagerMediatorDidRemoved(temperatureId: Int)
    func temperatureManagerMediatorDidRemovedAll(for memberId: Int)
}
