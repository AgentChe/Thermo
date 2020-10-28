//
//  MainViewController.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.10.2020.
//

import UIKit
import RxSwift

final class MainViewController: UIViewController {
    var mainView = MainView()
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = MainViewModel()
    
    private lazy var coordinator: MainCoordinator = {
        MainCoordinator(parentVC: self)
    }()
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addActionsToTabs()
        
        coordinator.temperatureListVC.delegate = self
        
        update(selectedTab: .list)
    }
}

// MARK: Make 
extension MainViewController {
    static func make() -> MainViewController {
        MainViewController()
    }
}

// MARK: JournalViewControllerDelegate
extension MainViewController: JournalViewControllerDelegate {
    func journalViewControllerDidTappedMember() {
        present(MembersViewController.make(), animated: true)
    }
}
 
// MARK: Private
private extension MainViewController {
    func addActionsToTabs() {
        let logGesture = UITapGestureRecognizer()
        mainView.tabView.temperatureLogItem.isUserInteractionEnabled = true
        mainView.tabView.temperatureLogItem.addGestureRecognizer(logGesture)
        
        let listGesture = UITapGestureRecognizer()
        mainView.tabView.temperatureListItem.isUserInteractionEnabled = true
        mainView.tabView.temperatureListItem.addGestureRecognizer(listGesture)
        
        let reminderGesture = UITapGestureRecognizer()
        mainView.tabView.reminderItem.isUserInteractionEnabled = true
        mainView.tabView.reminderItem.addGestureRecognizer(reminderGesture)
        
        Observable
            .merge([
                logGesture.rx.event.map { _ in TabView.Tab.log },
                listGesture.rx.event.map { _ in TabView.Tab.list },
                reminderGesture.rx.event.map { _ in TabView.Tab.reminder }
            ])
            .subscribe(onNext: { [weak self] tab in
                self?.update(selectedTab: tab)
            })
            .disposed(by: disposeBag)
    }
    
    func update(selectedTab: TabView.Tab) {
        switch selectedTab {
        case .log:
            navigationController?.pushViewController(LoggerViewController.make(), animated: true)
        default:
            mainView.tabView.selectedTab = selectedTab
            
            coordinator.change(tab: selectedTab)
        }
    }
}
