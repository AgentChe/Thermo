//
//  MainCoordinator.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import UIKit

final class MainCoordinator {
    weak var parentVC: MainViewController?
    
    lazy var temperatureListVC = JournalViewController.make()
    lazy var reminderVC = ReminderViewController.make()
    
    lazy var temperatureListNC: ThermoNavigationController = {
        ThermoNavigationController(rootViewController: temperatureListVC)
    }()
    
    lazy var reminderNC: ThermoNavigationController = {
        ThermoNavigationController(rootViewController: reminderVC)
    }()
    
    private var previousVC: UIViewController?
    
    init(parentVC: MainViewController) {
        self.parentVC = parentVC
    }
    
    func change(tab: TabView.Tab) {
        switch tab {
        case .log:
            break
        case .list:
            changeVC(on: temperatureListNC)
        case .reminder:
            changeVC(on: reminderNC)
        }
    }
}

// MARK: Private
private extension MainCoordinator {
    func changeVC(on vc: UIViewController) {
        if let previousVC = self.previousVC {
            previousVC.willMove(toParent: nil)
            previousVC.view.removeFromSuperview()
            previousVC.removeFromParent()
        }
    
        self.previousVC = vc
        
        guard let parentVC = self.parentVC else {
            return
        }
    
        parentVC.addChild(vc)
        vc.view.frame = parentVC.mainView.container.bounds
        parentVC.mainView.container.addSubview(vc.view)
        vc.willMove(toParent: parentVC)
    }
}
