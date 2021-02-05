//
//  LWAViewController.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 05.02.2021.
//

import UIKit
import RxSwift

final class LWAViewController: UIViewController {
    lazy var mainView = LWAView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = LWAViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel
            .step
            .drive(onNext: { [weak self] step in
                self?.step(step)
            })
            .disposed(by: disposeBag)
        
        mainView
            .onboardingView
            .button.rx.tap
            .subscribe(onNext: { [weak self] in 
                self?.mainView.step = .measurement
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension LWAViewController {
    static func make() -> LWAViewController {
        LWAViewController()
    }
}

// MARK: Private
private extension LWAViewController {
    func step(_ step: LWAViewModel.Step) {
        switch step {
        case .created:
            navigationController?.popViewController(animated: true)
        case .error:
            Toast.notify(with: "LWA.FailedToCreate".localized, style: .danger)
        }
    }
}
