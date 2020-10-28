//
//  MembersViewController.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 29.10.2020.
//

import UIKit
import RxSwift

final class MembersViewController: UIViewController {
    var membersView = MembersView()
    
    private let viewModel = MembersViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = membersView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        membersView.tableView.didSelectMember = { [weak self] member in
            self?.viewModel.setCurrentMember.accept(member)
        }
        
        membersView
            .closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .step()
            .drive(onNext: { [weak self] step in
                switch step {
                case .elements(let elements):
                    self?.membersView.tableView.setup(elements: elements)
                case .error(let message):
                    Toast.notify(with: message, style: .danger)
                case .updatedCurrentMember:
                    self?.dismiss(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        membersView
            .addNewButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.present(AddMemberViewController.make(transition: .present), animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension MembersViewController {
    static func make() -> MembersViewController {
        let vc = MembersViewController()
        vc.modalPresentationStyle = .overCurrentContext
        return vc
    }
}
