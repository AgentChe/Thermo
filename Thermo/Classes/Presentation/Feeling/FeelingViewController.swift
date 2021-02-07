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
    
    private var slVC: SLViewController?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel
            .selected
            .drive(onNext: { [weak self] feeling in
                self?.selected(feeling: feeling)
            })
            .disposed(by: disposeBag)
        
        mainView
            .selectionView
            .symptomsButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let vc = FSelectionViewController.make(style: .symptoms)
                self?.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView
            .selectionView
            .medicationsButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let vc = FSelectionViewController.make(style: .medicines)
                self?.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        addFeelingActions()
        addMeasureAction()
    }
}

// MARK: Make
extension FeelingViewController {
    static func make() -> FeelingViewController {
        FeelingViewController()
    }
}

// MARK: Private
private extension FeelingViewController {
    func addFeelingActions() {
        let selectionView = mainView.selectionView
        
        let goodGesture = UITapGestureRecognizer()
        selectionView.goodView.isUserInteractionEnabled = true
        selectionView.goodView.addGestureRecognizer(goodGesture)
        
        let sickGesture = UITapGestureRecognizer()
        selectionView.sickView.isUserInteractionEnabled = true
        selectionView.sickView.addGestureRecognizer(sickGesture)
        
        let badGesture = UITapGestureRecognizer()
        selectionView.badView.isUserInteractionEnabled = true
        selectionView.badView.addGestureRecognizer(badGesture)
        
        let recoveredGesture = UITapGestureRecognizer()
        selectionView.recoveredView.isUserInteractionEnabled = true
        selectionView.recoveredView.addGestureRecognizer(recoveredGesture)
        
        Observable
            .merge(
                goodGesture.rx.event.map { event in Feeling.good },
                sickGesture.rx.event.map { event in Feeling.sick },
                badGesture.rx.event.map { event in Feeling.bad },
                recoveredGesture.rx.event.map { event in Feeling.recovered }
            )
            .bind(to: viewModel.select)
            .disposed(by: disposeBag)
    }
    
    func addMeasureAction() {
        let gesture = UITapGestureRecognizer()
        mainView.measureView.isUserInteractionEnabled = true
        mainView.measureView.addGestureRecognizer(gesture)
        
        gesture.rx.event
            .subscribe(onNext: { [weak self] event in
                let vc = SLViewController.make { select in
                    self?.selected(type: select)
                }
                self?.navigationController?.present(vc, animated: false)
                
                self?.slVC = vc
            })
            .disposed(by: disposeBag)
    }
    
    func selected(type: SLViewController.Select) {
        slVC?.dismiss(animated: false) { [weak self] in
            switch type {
            case .withApp:
                let vc = LWAViewController.make()
                self?.navigationController?.pushViewController(vc, animated: true)
            case .manually:
                break
            }
        }
    }
    
    func selected(feeling: Feeling) {
        let selectionView = mainView.selectionView
        
        selectionView.goodView.checkedView.isHidden = feeling != .good
        selectionView.sickView.checkedView.isHidden = feeling != .sick
        selectionView.badView.checkedView.isHidden = feeling != .bad
        selectionView.recoveredView.checkedView.isHidden = feeling != .recovered
    }
}
