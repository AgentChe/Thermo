//
//  MembersManagerMediator.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import RxSwift
import RxCocoa

final class MembersManagerMediator {
    static let shared = MembersManagerMediator()
    
    private var delegates = [Weak<MembersManagerMediatorDelegate>]()
    
    private let didAddedTrigger = PublishRelay<Member>()
    private let didRemovedTrigger = PublishRelay<Int>()
    private let didSetCurrentTrigger = PublishRelay<Member>()
    
    private init() {}
}

// MARK: API
extension MembersManagerMediator {
    func notifyAboutAdded(member: Member) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.membersManagerMediatorDidAdded(member: member)
            }
            
            self?.didAddedTrigger.accept(member)
        }
    }
    
    func notifyAboutRemoved(memberId: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.membersManagerMediatorDidRemoved(memberId: memberId)
            }
            
            self?.didRemovedTrigger.accept(memberId)
        }
    }
    
    func notifyAboutSetCurrent(member: Member) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.membersManagerMediatorDidSetCurrent(member: member)
            }
            
            self?.didSetCurrentTrigger.accept(member)
        }
    }
}

// MARK: Triggers(Rx)
extension MembersManagerMediator {
    var rxDidAdded: Signal<Member> {
        didAddedTrigger.asSignal()
    }
    
    var rxDidRemoved: Signal<Int> {
        didRemovedTrigger.asSignal()
    }
    
    var rxDidSetCurrentMember: Signal<Member> {
        didSetCurrentTrigger.asSignal()
    }
}

// MARK: Observer
extension MembersManagerMediator {
    func add(delegate: MembersManagerMediatorDelegate) {
        let weakly = delegate as AnyObject
        delegates.append(Weak<MembersManagerMediatorDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }

    func remove(delegate: MembersManagerMediatorDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === delegate }) {
            delegates.remove(at: index)
        }
    }
}
