//
//  MembersManager.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.10.2020.
//

import RxSwift

protocol MembersManager: class {
    // MARK: API
    func add(memberUnit: MemberUnit,
             temperatureUnit: TemperatureUnit,
             imageKey: String,
             name: String,
             gender: Gender,
             dateBirthday: Date,
             setAsCurrent: Bool) -> Member?
    func remove(memberId: Int)
    func has(memberUnit: MemberUnit) -> Bool
    func get(memberId: Int) -> Member?
    func getAllMembers() -> [Member]
    func setCurrent(member: Member)
    func currentMember() -> Member?
    
    // MARK: API(Rx)
    func rxAdd(memberUnit: MemberUnit,
               temperatureUnit: TemperatureUnit,
               imageKey: String,
               name: String,
               gender: Gender,
               dateBirthday: Date,
               setAsCurrent: Bool) -> Single<Member?>
    func rxRemove(memberId: Int) -> Completable
    func rxHas(memberUnit: MemberUnit) -> Single<Bool>
    func rxGet(memberId: Int) -> Single<Member?>
    func rxGetAllMembers() -> Single<[Member]>
    func rxSetCurrent(member: Member) -> Completable
    func rxCurrentMember() -> Single<Member?>
}
