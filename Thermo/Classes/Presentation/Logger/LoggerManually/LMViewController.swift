//
//  LMViewController.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 08.02.2021.
//

import UIKit
import RxSwift

final class LMViewController: UIViewController {
    lazy var mainView = LMView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = LMViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel
            .temperatureRange
            .drive(onNext: { [weak self] range in
                self?.mainView.range = range
            })
            .disposed(by: disposeBag)
        
        viewModel
            .step
            .drive(onNext: { [weak self] step in
                self?.step(step)
            })
            .disposed(by: disposeBag)
        
        mainView
            .continueButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let this = self else {
                    return
                }
                
                let temperature = this.mainView.value
                
                this.viewModel.create.accept(temperature)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension LMViewController {
    static func make() -> LMViewController {
        LMViewController()
    }
}

// MARK: PaygateViewControllerDelegate
extension LMViewController: PaygateViewControllerDelegate {
    func paygateDidClosed(with result: PaygateViewControllerResult) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: Private
private extension LMViewController {
    func step(_ step: LMViewModel.Step) {
        switch step {
        case .created(let showPaygate):
            if showPaygate {
                openPaygate(needDelegate: true)
            } else {
                navigationController?.popViewController(animated: true)
            }
        case .error:
            Toast.notify(with: "LM.FailedToCreate".localized, style: .danger)
        case .paygate:
            openPaygate(needDelegate: false)
        }
    }
    
    func openPaygate(needDelegate: Bool) {
        let vc = PaygateViewController.make()
        if needDelegate {
            vc.delegate = self
        }
        present(vc, animated: true)
    }
}
