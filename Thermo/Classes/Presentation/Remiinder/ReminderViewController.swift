//
//  ReminderViewController.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import UIKit
import RxSwift

final class ReminderViewController: UIViewController {
    var reminderView = ReminderView()
    
    private let viewModel = ReminderViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = reminderView
    }
}

// MARK: Make
extension ReminderViewController {
    static func make() -> ReminderViewController {
        ReminderViewController()
    }
}
