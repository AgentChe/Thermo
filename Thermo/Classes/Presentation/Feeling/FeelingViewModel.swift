//
//  FeelingViewModel.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 04.02.2021.
//

import RxSwift
import RxCocoa

final class FeelingViewModel {
    lazy var select = PublishRelay<Feeling>()
    
    private lazy var feelingManager = FeelingManagerCore()
    
    lazy var selected = makeSelected()
}

// MARK: Private
private extension FeelingViewModel {
    func makeSelected() -> Driver<Feeling> {
        let initial = feelingManager
            .rxGetSelected()
            .asDriver(onErrorDriveWith: .empty())
        
        let updated = select
            .flatMapLatest { [weak self] feeling -> Single<Feeling> in
                guard let this = self else {
                    return .never()
                }
                
                return this.feelingManager
                    .rxSet(feeling: feeling)
                    .map { void in feeling }
            }
            .asDriver(onErrorDriveWith: .empty())
        
        return Driver
            .merge([
                initial, updated
            ])
    }
}
