//
//  RCViewController.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 04.02.2021.
//

import UIKit
import RxSwift

final class RCViewController: UIViewController {
    lazy var mainView = RCView()
    
    private lazy var viewModel = RCViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
}

// MARK: Make
extension RCViewController {
    static func make() -> RCViewController {
        RCViewController()
    }
}

