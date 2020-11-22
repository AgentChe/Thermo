//
//  ReportViewController.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 22.11.2020.
//

import UIKit
import RxSwift
import RxCocoa

final class ReportViewController: UIViewController {
    var mainView = ReportView()
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = ReportViewModel()
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView
            .closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView
            .sendButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.handleSendTapped()
            })
            .disposed(by: disposeBag)
        
        viewModel
            .step
            .drive(onNext: { [weak self] step in
                switch step {
                case .created:
                    self?.dismiss(animated: true)
                case .failure:
                    Toast.notify(with: "Report.CreateFailure".localized, style: .danger)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension ReportViewController {
    static func make() -> ReportViewController {
        ReportViewController()
    }
}

// MARK: Private
private extension ReportViewController {
    func handleSendTapped() {
        let email = mainView.emailField.text ?? ""
        let valid = isValid(email: email)
        
        mainView.invalidEmailView.isHidden = valid
        
        if valid {
            viewModel.create.accept(email)
        }
    }
    
    func isValid(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
