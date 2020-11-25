//
//  TemperatureManagerMediatorDelegate.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

protocol RecordManagerMediatorDelegate: class {
    func recordManagerMediatorDidLogged(record: Record)
    func recordManagerMediatorDidRemoved(recordId: Int)
    func recordManagerMediatorDidRemovedAll(for memberId: Int)
}
