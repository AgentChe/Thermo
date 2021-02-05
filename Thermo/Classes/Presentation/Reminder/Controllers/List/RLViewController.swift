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
    
    private lazy var pushNotificationsManager = SDKStorage.shared.pushNotificationsManager
    
    override func loadView() {
        view = mainView
    }
    
    let t = ReminderManagerCore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        t.addRemindAt(time: Date(), weekday: .monday)
//        t.addRemindAt(time: Date().addingTimeInterval(3415), weekday: .monday)
//        t.addRemindAt(time: Date().addingTimeInterval(2412), weekday: .saturday)
//        t.addRemindAt(time: Date().addingTimeInterval(34252), weekday: .thursday)
//        t.addRemindAt(time: Date().addingTimeInterval(5321), weekday: .wednesday)
        
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
        
        mainView
            .tableView.didRemove = { [weak self] reminder in
                self?.viewModel.removeReminder.accept(reminder.reminder)
            }
        
        viewModel
            .subscriveOnChangesAndUpdateNotificationsTriggers()
            .emit()
            .disposed(by: disposeBag)
        
        registerPush()
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
    func registerPush() {
        pushNotificationsManager.retriveAuthorizationStatus { [weak self] status in
            if status == .notDetermined {
                self?.pushNotificationsManager.requestAuthorization()
            }
        }
    }
    
    func goToCreate() {
        navigationController?.pushViewController(RCViewController.make(), animated: true)
    }
}
