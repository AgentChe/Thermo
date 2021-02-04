//
//  RLViewModel.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 04.02.2021.
//

import RxSwift
import RxCocoa

final class RLViewModel {
    lazy var elements = makeElements()
}

// MARK: Private
private extension RLViewModel {
    func makeElements() -> Driver<[RLTableElement]> {
        .deferred {
            .just([
                RLTableElement(), RLTableElement(), RLTableElement()
            ])
        }
    }
}
