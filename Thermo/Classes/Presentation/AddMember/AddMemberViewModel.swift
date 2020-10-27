//
//  AddMemberViewModel.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.10.2020.
//

import RxSwift
import RxCocoa

final class AddMemberViewModel {
    enum Step {
        case added(Member)
        case error(String)
    }
    
    let selectMemberUnit = PublishRelay<MemberUnit>()
    let selectTemperatureUnit = PublishRelay<TemperatureUnit>()
    
    let addMember = PublishRelay<Void>()
    
    private let membersManager = MembersManagerCore()
    
    func disabledMembersUnits() -> Driver<[MemberUnit]> {
        membersManager
            .rxGetAllMembers()
            .map { $0.map { $0.unit } }
            .asDriver(onErrorJustReturn: [])
    }
    
    func step() -> Driver<Step> {
        let stub = Observable
            .combineLatest(
                selectMemberUnit.asObservable(),
                selectTemperatureUnit.asObservable()
            )
        
        return addMember
            .withLatestFrom(stub)
            .flatMapLatest { [weak self] stub -> Single<Member?> in
                guard let this = self else {
                    return .never()
                }
                
                let (memberUnit, temperatureUnit) = stub
                
                return this.membersManager
                    .rxAdd(memberUnit: memberUnit, temperatureUnit: temperatureUnit, setAsCurrent: true)
                    .catchErrorJustReturn(nil)
            }
            .map { member -> Step in
                if let _member = member {
                    return .added(_member)
                } else {
                    return .error("AddMember.Add.Failure".localized)
                }
            }
            .asDriver(onErrorJustReturn: .error("AddMember.Add.Failure".localized))
    }
}
