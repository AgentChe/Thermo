//
//  TemperatureManagerMediator.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import RxSwift
import RxCocoa

final class RecordManagerMediator {
    static let shared = RecordManagerMediator()
    
    private let addedRecordTrigger = PublishRelay<Record>()
    
    private var delegates = [Weak<RecordManagerMediatorDelegate>]()
    
    private init() {}
}

// MARK: API
extension RecordManagerMediator {
    func notifyAboutLogged(record: Record) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.recordManagerMediatorDidAdded(record: record)
            }
            
            self?.addedRecordTrigger.accept(record)
        }
    }
}

// MARK: Triggers(Rx)
extension RecordManagerMediator {
    var rxLoggedRecord: Signal<Record> {
        addedRecordTrigger.asSignal()
    }
}

// MARK: Observer
extension RecordManagerMediator {
    func add(delegate: RecordManagerMediatorDelegate) {
        let weakly = delegate as AnyObject
        delegates.append(Weak<RecordManagerMediatorDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }

    func remove(delegate: RecordManagerMediatorDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === delegate }) {
            delegates.remove(at: index)
        }
    }
}
