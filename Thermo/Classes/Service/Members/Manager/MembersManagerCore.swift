//
//  MembersManagerCore.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.10.2020.
//

import RxSwift

final class MembersManagerCore: MembersManager {
    struct Constants {
        static let storedMembersKey = "members_manager_core_stored_members_key"
        static let currentMemberKey = "members_manager_core_current_member_key"
    }
}

// MARK: API
extension MembersManagerCore {
    func add(memberUnit: MemberUnit,
             temperatureUnit: TemperatureUnit,
             imageKey: String,
             name: String,
             gender: Gender,
             dateBirthday: Date,
             setAsCurrent: Bool = false) -> Member? {
        var members = getAllMembers()
        
        let member = Member(id: Int.random(in: 0..<Int.max),
                            unit: memberUnit,
                            temperatureUnit: temperatureUnit,
                            imageKey: imageKey,
                            name: name,
                            gender: gender,
                            dateBirthday: dateBirthday)
    
        members.append(member)
        
        guard store(members: members) else {
            return nil
        }
        
        MembersManagerMediator.shared.notifyAboutAdded(member: member)
        
        if setAsCurrent {
            setCurrent(member: member)
        }
        
        return member
    }
    
    func remove(memberId: Int) {
        var members = getAllMembers()
        members.removeAll(where: { $0.id == memberId })
        
        store(members: members)
        
        if currentMember()?.id == memberId {
            removeCurrentMember()
        }
        
        MembersManagerMediator.shared.notifyAboutRemoved(memberId: memberId)
    }
    
    func has(memberUnit: MemberUnit) -> Bool {
        getAllMembers().contains(where: { $0.unit == memberUnit })
    }
    
    func get(memberId: Int) -> Member? {
        getAllMembers().first(where: { $0.id == memberId })
    }
    
    func getAllMembers() -> [Member] {
        guard
            let data = UserDefaults.standard.data(forKey: Constants.storedMembersKey),
            let members = try? JSONDecoder().decode([Member].self, from: data)
        else {
            return []
        }
        
        return members
    }
    
    func setCurrent(member: Member) {
        guard let data = try? JSONEncoder().encode(member) else {
            return
        }
        
        UserDefaults.standard.setValue(data, forKey: Constants.currentMemberKey)
        
        MembersManagerMediator.shared.notifyAboutSetCurrent(member: member)
    }
    
    func currentMember() -> Member? {
        if
            let currentMemberData = UserDefaults.standard.data(forKey: Constants.currentMemberKey),
            let currentMember = try? JSONDecoder().decode(Member.self, from: currentMemberData) {
            return currentMember
        }
        
        return getAllMembers().first
    }
}

// MARK: API(Rx)
extension MembersManagerCore {
    func rxAdd(memberUnit: MemberUnit,
               temperatureUnit: TemperatureUnit,
               imageKey: String,
               name: String,
               gender: Gender,
               dateBirthday: Date,
               setAsCurrent: Bool = false) -> Single<Member?> {
        Single<Member?>
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                let member = this.add(memberUnit: memberUnit,
                                      temperatureUnit: temperatureUnit,
                                      imageKey: imageKey,
                                      name: name,
                                      gender: gender,
                                      dateBirthday: dateBirthday,
                                      setAsCurrent: setAsCurrent)
                
                event(.success(member))
                
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
    
    func rxHas(memberUnit: MemberUnit) -> Single<Bool> {
        Single<Bool>
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                event(.success(this.has(memberUnit: memberUnit)))
                
                return Disposables.create()
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.asyncInstance)
    }
    
    func rxGet(memberId: Int) -> Single<Member?> {
        Single<Member?>
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                event(.success(this.get(memberId: memberId)))
                
                return Disposables.create()
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.asyncInstance)
    }
    
    func rxGetAllMembers() -> Single<[Member]> {
        Single<[Member]>
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                event(.success(this.getAllMembers()))
                
                return Disposables.create()
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.asyncInstance)
    }
    
    func rxSetCurrent(member: Member) -> Completable {
        Completable
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                this.setCurrent(member: member)
                
                event(.completed)
                
                return Disposables.create()
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.asyncInstance)
    }
    
    func rxCurrentMember() -> Single<Member?> {
        Single<Member?>
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                event(.success(this.currentMember()))
                
                return Disposables.create()
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.asyncInstance)
    }
}

// MARK: Private
private extension MembersManagerCore {
    @discardableResult
    func store(members: [Member]) -> Bool {
        guard let data = try? JSONEncoder().encode(members) else {
            return false
        }
        
        UserDefaults.standard.setValue(data, forKey: Constants.storedMembersKey)
        
        return true
    }
    
    func removeCurrentMember() {
        UserDefaults.standard.removeObject(forKey: Constants.currentMemberKey)
    }
}
