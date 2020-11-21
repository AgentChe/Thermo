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
    let selectGender = PublishRelay<Gender>()
    let selectTemperatureUnit = PublishRelay<TemperatureUnit>()
    let createImageKey = PublishRelay<String>()
    let inputName = PublishRelay<String>()
    let inputDateBirthday = PublishRelay<Date>()
    
    let addMember = PublishRelay<Void>()
    
    private let membersManager = MembersManagerCore()
    private let imageManager = ImageManagerCore()
    
    func existingMembersUnits() -> Driver<[MemberUnit]> {
        membersManager
            .rxGetAllMembers()
            .map { $0.map { $0.unit } }
            .asDriver(onErrorJustReturn: [])
    }
    
    func store(image: UIImage) -> Driver<String> {
        let key = UUID().uuidString
        
        return imageManager
            .rxStore(image: image, key: key)
            .andThen(Single<String>.just(key))
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func step() -> Driver<Step> {
        let stub = Observable
            .combineLatest(
                selectMemberUnit.asObservable(),
                selectGender.asObservable(),
                selectTemperatureUnit.asObservable(),
                createImageKey.asObservable(),
                inputName.asObservable(),
                inputDateBirthday.asObservable()
            )
        
        return addMember
            .withLatestFrom(stub)
            .flatMapLatest { [weak self] stub -> Single<Member?> in
                guard let this = self else {
                    return .never()
                }
                
                let (memberUnit,
                     gender,
                     temperatureUnit,
                     imageKey,
                     name,
                     dateBirthday) = stub
                
                return this.membersManager
                    .rxAdd(memberUnit: memberUnit,
                           temperatureUnit: temperatureUnit,
                           imageKey: imageKey,
                           name: name,
                           gender: gender,
                           dateBirthday: dateBirthday,
                           setAsCurrent: true)
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
