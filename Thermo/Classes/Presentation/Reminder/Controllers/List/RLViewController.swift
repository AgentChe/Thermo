//
//  RLViewController.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 04.02.2021.
//

import UIKit
import RxSwift

final class RLViewController: UIViewController {
    lazy var mainView = RLView()
    
    private lazy var viewModel = RLViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel
            .elements
            .drive(onNext: { [weak self] elements in
                self?.mainView.tableView.setup(elements: elements)
                
                self?.mainView.tableView.isHidden = elements.isEmpty
                self?.mainView.emptyView.isHidden = !elements.isEmpty
                self?.mainView.addButton.isHidden = elements.isEmpty
            })
            .disposed(by: disposeBag)
        
        mainView
            .addButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.goToCreate()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension RLViewController {
    static func make() -> RLViewController {
        RLViewController()
    }
}

// MARK: Private
private extension RLViewController {
    func goToCreate() {
        navigationController?.pushViewController(RCViewController.make(), animated: true)
    }
}
