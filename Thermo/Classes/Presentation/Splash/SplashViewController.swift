//
//  SplashViewController.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 26.10.2020.
//

import UIKit
import RxSwift
import RxCocoa

final class SplashViewController: UIViewController {
    var splashView = SplashView()
    
    private let generateStep: Signal<Void>
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = SplashViewModel()
    
    private init(generateStep: Signal<Void>) {
        self.generateStep = generateStep
        
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = splashView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateStep
            .delay(RxTimeInterval.seconds(1))
            .flatMap { [weak self] in
                self?.viewModel.step() ?? .empty()
            }
            .drive(onNext: { [weak self] step in
                switch step {
                case .onboarding:
                    self?.goToOnboarding()
                case .addMember:
                    self?.goToAddMember()
                case .main:
                    self?.goToMain()
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension SplashViewController {
    static func make(generateStep: Signal<Void>) -> SplashViewController {
        SplashViewController(generateStep: generateStep)
    }
}

// MARK: Private
private extension SplashViewController {
    func goToOnboarding() {
        UIApplication.shared.keyWindow?.rootViewController = OnboardingViewController.make()
    }
    
    func goToAddMember() {
        UIApplication.shared.keyWindow?.rootViewController = AddMemberViewController.make()
    }
    
    func goToMain() {
        let vc = ThermoNavigationController(rootViewController: MainViewController.make())
        UIApplication.shared.keyWindow?.rootViewController = vc
    }
}
