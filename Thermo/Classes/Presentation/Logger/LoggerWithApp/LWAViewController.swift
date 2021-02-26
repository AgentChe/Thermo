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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = UIColor(integralRed: 2, green: 13, blue: 14)
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
        
        mainView.measurementView
            .pulseResult
            .bind(to: viewModel.pulse)
            .disposed(by: disposeBag)
        
        mainView.measurementView
            .cameraAccessDenied
            .bind(to: Binder(self) { base, _ in
                base.showPermissionAlert()
            })
            .disposed(by: disposeBag)
        
        mainView
            .resultView
            .button.rx.tap
            .withLatestFrom(viewModel.temperature)
            .bind(to: viewModel.create)
            .disposed(by: disposeBag)
        
        viewModel
            .lwaResult
            .drive(onNext: { [weak self] in
                self?.mainView.resultView.setup(result: $0)
                self?.mainView.step = .result
            })
            .disposed(by: disposeBag)
        
        viewModel
            .currentTemperatureUnit
            .drive(onNext: { [weak self] currentTemperatureUnit in
                self?.mainView.measurementView.temperatureUnit = currentTemperatureUnit
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

// MARK: PaygateViewControllerDelegate
extension LWAViewController: PaygateViewControllerDelegate {
    func paygateDidClosed(with result: PaygateViewControllerResult) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: Private
private extension LWAViewController {
    func step(_ step: LWAViewModel.Step) {
        switch step {
        case .created(let showPaygate):
            if showPaygate {
                openPaygate(needDelegate: true)
            } else {
                navigationController?.popViewController(animated: true)
            }
        case .error:
            Toast.notify(with: "LWA.FailedToCreate".localized, style: .danger)
        case .paygate:
            openPaygate(needDelegate: false)
        }
    }
    
    func showPermissionAlert() {
        let controller = UIAlertController(title: nil, message: "LWA.Measurenment.Alert.CameraDenied".localized, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".localized, style: .cancel) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        controller.addAction(okAction)
        present(controller, animated: true)
    }
    
    func openPaygate(needDelegate: Bool) {
        let vc = PaygateViewController.make()
        if needDelegate {
            vc.delegate = self
        }
        present(vc, animated: true)
    }
}
