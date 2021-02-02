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
    var journalView = JournalView()
    
    private let viewModel = JournalViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = journalView
    }
}

// MARK: Make
extension JournalViewController {
    static func make() -> JournalViewController {
        JournalViewController()
    }
}
