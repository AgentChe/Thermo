//
//  JournalViewController.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import UIKit
import RxSwift
import RxCocoa

final class JournalViewController: UIViewController {
    weak var delegate: JournalViewControllerDelegate?
    
    var mainView = JournalView()
    
    private let viewModel = JournalViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel
            .sections
            .drive(onNext: { [weak self] sections in
                self?.mainView.tableView.setup(sections: sections)
                
                self?.mainView.tableView.isHidden = sections.isEmpty
                self?.mainView.emptyView.isHidden = !sections.isEmpty
            })
            .disposed(by: disposeBag)
        
        mainView
            .emptyView
            .button.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.delegate?.journalViewControllerAdd()
            })
            .disposed(by: disposeBag)
        
        mainView
            .filterView.filter
            .bind(to: viewModel.filter)
            .disposed(by: disposeBag)
        
        mainView.filterView.journalVC = self
    }
}

// MARK: Make
extension JournalViewController {
    static func make() -> JournalViewController {
        JournalViewController()
    }
}
