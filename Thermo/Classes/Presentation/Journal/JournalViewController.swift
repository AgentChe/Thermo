//
//  JournalViewController.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import UIKit
import RxSwift

final class JournalViewController: UIViewController {
    weak var delegate: JournalViewControllerDelegate?
    
    var journalView = JournalView()
    
    private let viewModel = JournalViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = journalView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addActionsToMember()
        
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

// MARK: Private
private extension JournalViewController {
    func addActionsToMember() {
        let tapGesture = UITapGestureRecognizer()
        journalView.imageView.isUserInteractionEnabled = true
        journalView.imageView.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.delegate?.journalViewControllerDidTappedMember()
            })
            .disposed(by: disposeBag)
    }
}
