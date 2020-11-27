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
    
    let addMember = PublishRelay<AMMemberAttributionsMaker.AMMemberAttributions>()
    
    private let membersManager = MembersManagerCore()
    private let imageManager = ImageManagerCore()
    private let sessionManager = SessionManagerCore()
    private let monetizationManager = MonetizationManagerCore()
    
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
                    case .animal:
                        return .animal
                    case .object:
                        return .object
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
        let needPayment = self.needPayment()
        
        return addMember
            .withLatestFrom(needPayment) { ($0, $1) }
            .flatMapLatest { [weak self] stub -> Single<Step> in
                guard let this = self else {
                    return .never()
                }
                
                let (attributions, needPayment) = stub
                
                guard !needPayment else {
                    return .just(.paygate)
                }
                
                let (memberUnit, temperatureUnit) = attributions
                
                return this.membersManager
                    .rxAdd(memberUnit: memberUnit, temperatureUnit: temperatureUnit, setAsCurrent: true)
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
            .catchErrorJustReturn(0)
            .asObservable()
        
        let freeMembers = monetizationManager
            .rxRetrieveMonetizationConfig(forceUpdate: false)
            .map { $0?.maxFreeProfiles ?? 0 }
            .catchErrorJustReturn(0)
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
            .combineLatest(membersCount, freeMembers, activeSubscription)
            .map { membersCount, freeMembers, activeSubscription -> Bool in
                guard membersCount >= freeMembers else {
                    return false
                }
                
                return !activeSubscription
            }
    }
}
