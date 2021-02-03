//
//  MainViewController.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.10.2020.
//

import UIKit
import RxSwift

final class MainViewController: UIViewController {
    lazy var mainView = MainView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var coordinator = MainCoordinator(parentVC: self)
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rx.methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                self?.update(selectedTab: .feeling)
            })
            .disposed(by: disposeBag)
        
        addActionsToTabs()
    }
}

// MARK: Make 
extension MainViewController {
    static func make() -> MainViewController {
        MainViewController()
    }
}
 
// MARK: Private
private extension MainViewController {
    func addActionsToTabs() {
        let reminderGesture = UITapGestureRecognizer()
        mainView.tabView.reminderItem.isUserInteractionEnabled = true
        mainView.tabView.reminderItem.addGestureRecognizer(reminderGesture)
        
        let feelingGesture = UITapGestureRecognizer()
        mainView.tabView.feelingItem.isUserInteractionEnabled = true
        mainView.tabView.feelingItem.addGestureRecognizer(feelingGesture)
        
        let journalGesture = UITapGestureRecognizer()
        mainView.tabView.journalItem.isUserInteractionEnabled = true
        mainView.tabView.journalItem.addGestureRecognizer(journalGesture)
        
        Observable
            .merge([
                reminderGesture.rx.event.map { _ in TabView.Tab.reminder },
                feelingGesture.rx.event.map { _ in TabView.Tab.feeling },
                journalGesture.rx.event.map { _ in TabView.Tab.journal }
                
            ])
            .subscribe(onNext: { [weak self] tab in
                self?.update(selectedTab: tab)
            })
            .disposed(by: disposeBag)
    }
    
    func update(selectedTab: TabView.Tab) {
        coordinator.change(tab: selectedTab)
    }
}
