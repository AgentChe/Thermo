//
//  JournalViewController.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import UIKit
import RxSwift

final class JournalViewController: UIViewController {
    var journalView = JournalView()
    
    private let viewModel = JournalViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = journalView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel
            .elements()
            .drive(onNext: { [weak self] elements in
                self?.journalView.tableView.setup(elements: elements)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension JournalViewController {
    static func make() -> JournalViewController {
        JournalViewController()
    }
}
