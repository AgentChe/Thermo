//
//  MembersViewModel.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 29.10.2020.
//

import RxSwift
import RxCocoa

final class MembersViewModel {
    enum Step {
        case elements([Member])
        case updatedCurrentMember
        case error(String)
    }
    
    let setCurrentMember = PublishRelay<Member>()
    
    private let membersManager = MembersManagerCore()
    
    func step() -> Driver<Step> {
        Driver
            .merge([
                elements()
                    .map { Step.elements($0) },
                
                updateCurrentMember()
            ])
    }
}

// MARK: Private
private extension MembersViewModel {
    func elements() -> Driver<[Member]> {
        Driver
            .combineLatest(
                membersManager
                    .rxGetAllMembers()
                    .asDriver(onErrorJustReturn: []),
                
                MembersManagerMediator.shared
                    .rxDidAdded
                    .scan([Member]()) { added, new -> [Member] in
                        added + [new]
                    }
                    .startWith([])
                    .asDriver(onErrorJustReturn: []),
                
                MembersManagerMediator.shared
                    .rxDidRemoved
                    .scan([Int]()) { removed, new -> [Int] in
                        removed + [new]
                    }
                    .startWith([])
                    .asDriver(onErrorJustReturn: [])
            )
            .map { initial, added, removed -> [Member] in
                var result = initial + added
                
                for remove in removed {
                    result.removeAll(where: { $0.id == remove })
                }
                
                return result
            }
    }
    
    func updateCurrentMember() -> Driver<Step> {
        setCurrentMember
            .flatMapLatest { [weak self] member -> Single<Step> in
                guard let this = self else {
                    return .never()
                }
                
                return this.membersManager
                    .rxSetCurrent(member: member)
                    .andThen(Single.just(Step.updatedCurrentMember))
                    .catchAndReturn(Step.error("Members.SetCurrentMember".localized))
            }
            .asDriver(onErrorJustReturn: Step.error("Members.SetCurrentMember".localized))
    }
}
