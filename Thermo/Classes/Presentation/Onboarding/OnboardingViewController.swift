//
//  OnboardingViewController.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 26.10.2020.
//

import UIKit
import RxSwift

final class OnboardingViewController: UIViewController {
    struct Constants {
        static let wasViewedKey = "onboarding_view_controller_was_viewed_key"
    }
    
    var onboardingView = OnboardingView()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = onboardingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onboardingView
            .button.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.tapped()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension OnboardingViewController {
    static func make() -> OnboardingViewController {
        OnboardingViewController()
    }
}

// MARK: Private
private extension OnboardingViewController {
    func tapped() {
        let nextStepIndex = onboardingView.step.rawValue + 1
        
        guard let nextStep = OnboardingView.Step(rawValue: nextStepIndex) else {
            goToNext()
            
            return
        }
        
        onboardingView.step = nextStep
    }
    
    func goToNext() {
        UserDefaults.standard.setValue(true, forKey: Constants.wasViewedKey)
        
        UIApplication.shared.keyWindow?.rootViewController = AddMemberViewController.make()
    }
}
