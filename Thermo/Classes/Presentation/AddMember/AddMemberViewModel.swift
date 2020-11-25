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
        case paygate
    }
    
    let selectMemberUnit = PublishRelay<AMMemberUnit>()
    let selectGender = PublishRelay<Gender>()
    let selectTemperatureUnit = PublishRelay<TemperatureUnit>()
    let createImageKey = PublishRelay<String>()
    let inputName = PublishRelay<String>()
    let inputDateBirthday = PublishRelay<Date>()
    
    let addMember = PublishRelay<Void>()
    
    private let membersManager = MembersManagerCore()
    private let imageManager = ImageManagerCore()
    private let sessionManager = SessionManagerCore()
    
    func existingMembersUnits() -> Driver<[AMMemberUnit]> {
        membersManager
            .rxGetAllMembers()
            .map { members -> [AMMemberUnit] in
                members.map { member -> AMMemberUnit in
                    switch member.unit {
                    case .me:
                        return .me
                    case .child:
                        return .child
                    case .parent:
                        return .parent
                    case .other:
                        return .other
                    }
                }
            }
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
        let fields = Observable
            .combineLatest(
                selectMemberUnit.asObservable(),
                selectGender.asObservable(),
                selectTemperatureUnit.asObservable(),
                createImageKey.asObservable(),
                inputName.asObservable(),
                inputDateBirthday.asObservable()
            )
        
        let stub = Observable
            .combineLatest(fields, needPayment())
        
        return addMember
            .withLatestFrom(stub)
            .flatMapLatest { [weak self] stub -> Single<Step> in
                guard let this = self else {
                    return .never()
                }
                
                let (fields, needPayment) = stub
                
                guard !needPayment else {
                    return .just(.paygate)
                }
                
                let (memberUnit,
                     gender,
                     temperatureUnit,
                     imageKey,
                     name,
                     dateBirthday) = fields
                
                let human = Human(name: name,
                                  imageKey: imageKey,
                                  gender: gender,
                                  dateBirthday: dateBirthday)
                let unit: MemberUnit
                switch memberUnit {
                case .me:
                    unit = .me(human)
                case .child:
                    unit = .child(human)
                case .parent:
                    unit = .parent(human)
                case .other:
                    unit = .other(human)
                }
                
                return this.membersManager
                    .rxAdd(memberUnit: unit,
                           temperatureUnit: temperatureUnit,
                           setAsCurrent: true)
                    .catchErrorJustReturn(nil)
                    .map { member -> Step in
                        if let _member = member {
                            return .added(_member)
                        } else {
                            return .error("AddMember.Add.Failure".localized)
                        }
                    }
            }
            .asDriver(onErrorJustReturn: .error("AddMember.Add.Failure".localized))
    }
}

// MARK: Private
private extension AddMemberViewModel {
    func needPayment() -> Observable<Bool> {
        let membersCount = membersManager
            .rxGetAllMembers()
            .map { $0.count }
            .asObservable()
        
        let initial = Observable<Bool>.deferred { [weak self] in
            guard let this = self else {
                return .empty()
            }
            
            let activeSubscription = this.sessionManager.getSession()?.activeSubscription ?? false
            
            return .just(activeSubscription)
        }
        
        let updated = SDKStorage.shared
            .purchaseMediator
            .rxPurchaseMediatorDidValidateReceipt
            .map { $0?.activeSubscription ?? false }
            .asObservable()
        
        let activeSubscription = Observable
            .merge(initial, updated)
        
        return Observable
            .combineLatest(membersCount, activeSubscription)
            .map { membersCount, activeSubscription -> Bool in
                guard membersCount >= 1 else {
                    return false
                }
                
                return !activeSubscription
            }
    }
}
