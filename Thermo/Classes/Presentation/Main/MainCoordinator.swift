//
//  MainCoordinator.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import UIKit

final class MainCoordinator {
    weak var parentVC: MainViewController?
    
    lazy var reminderVC = RLViewController.make()
    lazy var feelingVC = FeelingViewController.make()
    lazy var journalVC: JournalViewController = {
        let vc = JournalViewController.make()
        vc.delegate = self
        return vc
    }()
    
    private var previousVC: UIViewController?
    
    init(parentVC: MainViewController) {
        self.parentVC = parentVC
    }
    
    func change(tab: TabView.Tab) {
        parentVC?.mainView.tabView.selectedTab = tab
        
        switch tab {
        case .reminder:
            changeVC(on: reminderVC)
        case .feeling:
            changeVC(on: feelingVC)
        case .journal:
            changeVC(on: journalVC)
        }
    }
}

// MARK: JournalViewControllerDelegate
extension MainCoordinator: JournalViewControllerDelegate {
    func journalViewControllerAdd() {
        change(tab: .feeling)
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
