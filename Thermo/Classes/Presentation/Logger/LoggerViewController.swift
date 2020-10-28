//
//  LoggerViewController.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import UIKit
import RxSwift

final class LoggerViewController: UIViewController {
    var loggerView = LoggerView()
    
    private let viewModel = LoggerViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = loggerView
    }
}

// MARK: Make
extension LoggerViewController {
    static func make() -> LoggerViewController {
        LoggerViewController()
    }
}
