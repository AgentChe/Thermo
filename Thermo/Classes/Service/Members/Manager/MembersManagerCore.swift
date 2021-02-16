//
//  MembersManagerCore.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.10.2020.
//

import RxSwift

final class MembersManagerCore: MembersManager {
    struct Constants {
        static let storedMemberKey = "members_manager_core_stored_member_key"
    }
}

// MARK: API
extension MembersManagerCore {
    func store(temperatureUnit: TemperatureUnit) -> Member? {
        let member = Member(id: Int.random(in: 0..<Int.max),
                            temperatureUnit: temperatureUnit)
        
        guard store(member: member) else {
            return nil
        }
        
        return member
    }
    
    func get() -> Member? {
        guard let data = UserDefaults.standard.data(forKey: Constants.storedMemberKey) else {
            return nil
        }
        
        return try? JSONDecoder().decode(Member.self, from: data)
    }
}

// MARK: API(Rx)
extension MembersManagerCore {
    func rxStore(temperatureUnit: TemperatureUnit) -> Single<Member?> {
        Single<Member?>
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                let member = this.store(temperatureUnit: temperatureUnit)
                
                event(.success(member))
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
    }
    
    func rxGet() -> Single<Member?> {
        Single<Member?>
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                event(.success(this.get()))
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
    }
}

// MARK: Private
private extension MembersManagerCore {
    @discardableResult
    func store(member: Member) -> Bool {
        guard let data = try? JSONEncoder().encode(member) else {
            return false
        }
        
        UserDefaults.standard.setValue(data, forKey: Constants.storedMemberKey)
        
        return true
    }
}
