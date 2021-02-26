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
    
    lazy var mainView = OnboardingView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = OnboardingViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        initializeSlider()
        
        mainView
            .button.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.nextTapped()
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

// MARK: API
extension OnboardingViewController {
    static func wasViewed() -> Bool {
        UserDefaults.standard.bool(forKey: OnboardingViewController.Constants.wasViewedKey)
    }
}

// MARK: OnboardingSliderDelegate
extension OnboardingViewController: OnboardingSliderDelegate {
    func onboardingSlider(changed slideIndex: Int) {
        mainView.indicatorsView.index = slideIndex
    }
}


// MARK: PaygateViewControllerDelegate
extension OnboardingViewController: PaygateViewControllerDelegate {
    func paygateDidClosed(with result: PaygateViewControllerResult) {
        openAddMemberController()
    }
}

// MARK: Private
private extension OnboardingViewController {
    func initializeSlider() {
        mainView.slider.setup(models: [
            OnboardingSlide(imageName: "Onboarding.Slide1", title: "Onboarding.Slide1.Title".localized),
            OnboardingSlide(imageName: "Onboarding.Slide2", title: "Onboarding.Slide2.Title".localized)
        ])
        
        mainView.slider.delegate = self
        
        mainView.indicatorsView.count = 2
        mainView.indicatorsView.index = 0
    }
    
    func nextTapped() {
        let currentIndex = mainView.indicatorsView.index
        
        if currentIndex == (mainView.indicatorsView.count - 1) {
            markAsViewed()
            goToNext()
        } else {
            mainView.slider.scroll(to: currentIndex + 1)
        }
    }
    
    func markAsViewed() {
        UserDefaults.standard.setValue(true, forKey: Constants.wasViewedKey)
    }
    
    func goToNext() {
        if viewModel.needPayment() {
            openPaygate()
        } else {
            openAddMemberController()
        }
    }
    
    func openAddMemberController() {
        UIApplication.shared.keyWindow?.rootViewController = AddMemberViewController.make()
    }
    
    func openPaygate() {
        let vc = PaygateViewController.make()
        vc.delegate = self
        present(vc, animated: true)
    }
}
