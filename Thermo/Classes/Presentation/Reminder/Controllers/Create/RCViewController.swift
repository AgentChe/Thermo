//
//  RCViewController.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 04.02.2021.
//

import UIKit
import RxSwift

final class RCViewController: UIViewController {
    lazy var mainView = RCView()
    
    private lazy var viewModel = RCViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel
            .step
            .drive(onNext: { [weak self] step in
                switch step {
                case .created:
                    self?.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        addCreateAction()
        addSelectionActions()
    }
}

// MARK: Make
extension RCViewController {
    static func make() -> RCViewController {
        RCViewController()
    }
}

// MARK: Private
private extension RCViewController {
    func addCreateAction() {
        let views = [
            mainView.mondayCell,
            mainView.tuesdayCell,
            mainView.wednesdayCell,
            mainView.thursdayCell,
            mainView.fridayCell,
            mainView.saturdayCell,
            mainView.sundayCell
        ]
        
        mainView
            .button.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let this = self else {
                    return
                }
                
                guard let selectedWeekday = views.first(where: { $0.isChecked })?.weekday else {
                    return 
                }
                
                let time = this.mainView.timePicker.date
                
                this.viewModel.create.accept((time, selectedWeekday))
            })
            .disposed(by: disposeBag)
    }
    
    func addSelectionActions() {
        Observable
            .merge(
                makeWeekday(on: mainView.mondayCell, weekday: .monday),
                makeWeekday(on: mainView.tuesdayCell, weekday: .tuesday),
                makeWeekday(on: mainView.wednesdayCell, weekday: .wednesday),
                makeWeekday(on: mainView.thursdayCell, weekday: .thursday),
                makeWeekday(on: mainView.fridayCell, weekday: .friday),
                makeWeekday(on: mainView.saturdayCell, weekday: .saturday),
                makeWeekday(on: mainView.sundayCell, weekday: .sunday)
            )
            .subscribe(onNext: { [weak self] weekday in
                self?.selected(weekday: weekday)
            })
            .disposed(by: disposeBag)
    }
    
    func selected(weekday: Weekday) {
        mainView.mondayCell.isChecked = weekday == .monday
        mainView.tuesdayCell.isChecked = weekday == .tuesday
        mainView.wednesdayCell.isChecked = weekday == .wednesday
        mainView.thursdayCell.isChecked = weekday == .thursday
        mainView.fridayCell.isChecked = weekday == .friday
        mainView.saturdayCell.isChecked = weekday == .saturday
        mainView.sundayCell.isChecked = weekday == .sunday
    }
    
    func makeWeekday(on view: UIView, weekday: Weekday) -> Observable<Weekday> {
        let tapGesture = UITapGestureRecognizer()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        
        return tapGesture.rx.event
            .map { event in weekday }
            .asObservable()
    }
}
