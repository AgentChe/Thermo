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
    private let medicinesManager = MedicineManagerCore()
    private let symptomsManager = SymptomsManagerCore()
    private let monetizationManager = MonetizationManagerCore()
    
    func step() -> Driver<Step> {
        library()
            .andThen(generateStep())
            .asDriver(onErrorDriveWith: .empty())
    }
}

// MARK: Private
private extension SplashViewModel {
    func library() -> Completable {
        Completable
            .zip([
                medicinesManager
                    .rxRetrieveMedicines(forceUpdate: true)
                    .catchAndReturn([])
                    .asCompletable(),
                
                symptomsManager
                    .rxRetrieveSymptoms(forceUpdate: true)
                    .catchAndReturn([])
                    .asCompletable(),
                
                monetizationManager
                    .rxRetrieveMonetizationConfig(forceUpdate: true)
                    .catchAndReturn(nil)
                    .asCompletable()
            ])
    }
    
    func generateStep() -> Observable<Step> {
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
