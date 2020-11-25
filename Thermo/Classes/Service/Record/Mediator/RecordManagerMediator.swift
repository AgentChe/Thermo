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
    
    private let loggedRecordTrigger = PublishRelay<Record>()
    private let removedRecordIdTrigger = PublishRelay<Int>()
    private let removedAllRecordsForMemberIdTrigger = PublishRelay<Int>()
    
    private var delegates = [Weak<RecordManagerMediatorDelegate>]()
    
    private init() {}
}

// MARK: API
extension RecordManagerMediator {
    func notifyAboutLogged(record: Record) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.recordManagerMediatorDidLogged(record: record)
            }
            
            self?.loggedRecordTrigger.accept(record)
        }
    }
    
    func notifyAboutRemoved(recordId: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.recordManagerMediatorDidRemoved(recordId: recordId)
            }
            
            self?.removedRecordIdTrigger.accept(recordId)
        }
    }
    
    func notifyAboutRemovedAllRecords(for memberId: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.recordManagerMediatorDidRemovedAll(for: memberId)
            }
            
            self?.removedAllRecordsForMemberIdTrigger.accept(memberId)
        }
    }
}

// MARK: Triggers(Rx)
extension RecordManagerMediator {
    var rxLoggedRecord: Signal<Record> {
        loggedRecordTrigger.asSignal()
    }
    
    var rxRemovedRecordId: Signal<Int> {
        removedRecordIdTrigger.asSignal()
    }
    
    var rxRemovedAllRecordsForMemberId: Signal<Int> {
        removedAllRecordsForMemberIdTrigger.asSignal()
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
