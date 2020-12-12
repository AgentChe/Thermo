//
//  TreatmentsViewController.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 02.12.2020.
//

import UIKit
import RxSwift

final class TreatmentsViewController: UIViewController {
    var mainView = TreatmentsView()
    
    private let viewModel = TreatmentsViewModel()
    
    private let disposeBag = DisposeBag()
    
    private var preloaderView: TCPreloaderView?
    private var listView: TCListView?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.loading
            .drive(onNext: preloader(active:))
            .disposed(by: disposeBag)
        
        viewModel
            .conditions()
            .drive(onNext: list(conditions:))
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension TreatmentsViewController {
    static func make() -> TreatmentsViewController {
        TreatmentsViewController()
    }
}

// MARK: Private(List)
private extension TreatmentsViewController {
    func list(conditions: [TreatmentCondition]) {
        if conditions.isEmpty {
            let alert = UIAlertController(title: nil, message: "Treatments.AlertEmptyText".localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel) { [weak self] action in
                self?.navigationController?.popViewController(animated: true)
            })
            present(alert, animated: true)
        } else {
            form(conditions: conditions)
        }
    }
    
    func form(conditions: [TreatmentCondition]) {
        let view = TCListView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.tapped = { [weak self] index in
            guard let this = self else {
                return
            }
            
            this.open(index: index, conditions: conditions)
        }
        
        mainView.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            view.topAnchor.constraint(equalTo: mainView.topAnchor),
            view.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
        ])
        
        view.conditions = conditions
        
        listView = view
    }
    
    func open(index: Int, conditions: [TreatmentCondition]) {
        guard conditions.indices.contains(index) else {
            return
        }
        
        let vc = TCConditionViewController.make(condition: conditions[index])
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: Private(Preloader)
private extension TreatmentsViewController {
    func preloader(active: Bool) {
        switch active {
        case true:
            showPreloader()
        case false:
            hidePreloader()
        }
    }
    
    func showPreloader() {
        let view = TCPreloaderView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        mainView.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            view.topAnchor.constraint(equalTo: mainView.topAnchor),
            view.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
        ])
        
        view.startAnimate()
        
        preloaderView = view 
    }
    
    func hidePreloader() {
        preloaderView?.stopAnimate()
        preloaderView?.removeFromSuperview()
        preloaderView = nil
    }
}
