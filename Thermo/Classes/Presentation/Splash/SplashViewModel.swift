//
//  SplashViewModel.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 26.10.2020.
//

import RxSwift
import RxCocoa

final class SplashViewModel {
    enum Step {
        case onboarding, logger, main
    }
    
    func step() -> Driver<Step> {
        .deferred {
            .just(Step.onboarding)
        }
    }
}
