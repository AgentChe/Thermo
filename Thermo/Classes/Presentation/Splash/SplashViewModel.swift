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
        case onboarding, addMember, main
    }
    
    private let membersManager = MembersManagerCore()
    
    func step() -> Driver<Step> {
        .deferred { [membersManager] in
            if !OnboardingViewController.wasViewed() {
                return .just(Step.onboarding)
            }
            
            if membersManager.getAllMembers().isEmpty {
                return .just(Step.addMember)
            }
            
            return .just(Step.main)
        }
    }
}
