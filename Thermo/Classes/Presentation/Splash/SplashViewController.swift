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
            .drive(onNext: { step in
                switch step {
                case .onboarding:
                    UIApplication.shared.keyWindow?.rootViewController = OnboardingViewController.make()
                case .logger:
                    break
                case .main:
                    break
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
