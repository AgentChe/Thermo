//
//  AddMemberViewController.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.10.2020.
//

import UIKit
import RxSwift

final class AddMemberViewController: UIViewController {
    lazy var mainView = AddMemberView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = AddMemberViewModel()
    
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
        
        addSelectActions()
        addButtonAction()
    }
}

// MARK: Make
extension AddMemberViewController {
    static func make() -> AddMemberViewController {
        AddMemberViewController()
    }
}

// MARK: Make
private extension AddMemberViewController {
    func step(_ step: AddMemberViewModel.Step) {
        switch step {
        case .main:
            let vc = ThermoNavigationController(rootViewController: MainViewController.make())
            UIApplication.shared.keyWindow?.rootViewController = vc
        case .error:
            Toast.notify(with: "AddMember.FailedStore".localized, style: .danger)
        }
    }
    
    func addSelectActions() {
        let fahrenheitTapGesture = UITapGestureRecognizer()
        mainView.fahrenheitCell.isUserInteractionEnabled = true
        mainView.fahrenheitCell.addGestureRecognizer(fahrenheitTapGesture)
        
        let celsiusTapGesture = UITapGestureRecognizer()
        mainView.celsiusCell.isUserInteractionEnabled = true
        mainView.celsiusCell.addGestureRecognizer(celsiusTapGesture)
        
        Observable
            .merge(fahrenheitTapGesture.rx.event.map { event in 0 },
                   celsiusTapGesture.rx.event.map { event in 1 })
            .subscribe(onNext: { [weak self] flag in
                guard let this = self else {
                    return
                }
                
                this.mainView.fahrenheitCell.isSelected = flag == 0
                this.mainView.celsiusCell.isSelected = flag == 1
            })
            .disposed(by: disposeBag)
    }
    
    func addButtonAction() {
        mainView
            .button.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let this = self else {
                    return
                }
                
                if this.mainView.fahrenheitCell.isSelected {
                    this.viewModel.store.accept(.fahrenheit)
                } else if this.mainView.celsiusCell.isSelected {
                    this.viewModel.store.accept(.celsius)
                }
            })
            .disposed(by: disposeBag)
    }
}
