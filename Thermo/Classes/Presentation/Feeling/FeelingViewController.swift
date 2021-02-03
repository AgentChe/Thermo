//
//  FeelingViewController.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 04.02.2021.
//

import UIKit
import RxSwift

final class FeelingViewController: UIViewController {
    lazy var mainView = FeelingView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = FeelingViewModel()
    
    override func loadView() {
        view = mainView
    }
}

extension FeelingViewController {
    static func make() -> FeelingViewController {
        FeelingViewController()
    }
}
