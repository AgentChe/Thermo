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
        case main, error
    }
    
    lazy var store = PublishRelay<TemperatureUnit>()
    
    lazy var step = makeStep()
    
    private lazy var membersManager = MembersManagerCore()
}

// MARK: Private
private extension AddMemberViewModel {
    func makeStep() -> Driver<Step> {
        store
            .flatMapLatest { [membersManager] temperatureUnit -> Single<Step> in
                membersManager
                    .rxStore(temperatureUnit: temperatureUnit)
                    .catchAndReturn(nil)
                    .map { $0 != nil ? Step.main : Step.error }
            }
            .asDriver(onErrorJustReturn: .error)
    }
}
