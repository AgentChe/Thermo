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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addReminderNavItem()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeReminderNavItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.sections()
            .drive(onNext: { [weak self] sections in
                self?.reminderView.tableView.setup(sections: sections)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension ReminderViewController {
    static func make() -> ReminderViewController {
        ReminderViewController()
    }
}

// MARK: Private
private extension ReminderViewController {
    func addReminderNavItem() {
        let item = UIBarButtonItem()
        item.image = UIImage(named: "Reminder.Add")
        item.tintColor = UIColor(integralRed: 0, green: 122, blue: 255)
        parent?.navigationItem.rightBarButtonItem = item
        
        item.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.openTimePicker()
            })
            .disposed(by: disposeBag)
    }
    
    func removeReminderNavItem() {
        parent?.navigationItem.rightBarButtonItem = nil
    }
    
    func openTimePicker() {
        let timeView = ReminderSelectTimeView(frame: reminderView.frame)
        timeView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        reminderView.addSubview(timeView)
        
        timeView
            .button.rx.tap
            .subscribe(onNext: { [weak self] in
                let date = timeView.timePicker.date
                self?.viewModel.addRemindAt.accept(date)
                
                timeView.removeFromSuperview()
            })
            .disposed(by: disposeBag)
    }
}
