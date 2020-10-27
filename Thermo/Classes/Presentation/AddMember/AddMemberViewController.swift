//
//  AddMemberViewController.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.10.2020.
//

import UIKit
import RxSwift

final class AddMemberViewController: UIViewController {
    // Как был открыт vc, чтобы понять, как его закрыть
    enum Transition {
        case push
        case present
        case root
    }
    
    var addMemberView = AddMemberView()
    
    private let viewModel = AddMemberViewModel()
    
    private let disposeBag = DisposeBag()
    
    private let transition: Transition
    
    private init(transition: Transition) {
        self.transition = transition
        
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = addMemberView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addMemberUnitActions()
        addTemperatureUnitActions()
        
        viewModel
            .disabledMembersUnits()
            .drive(onNext: { [weak self] units in
                self?.disableMembersUnits(units)
            })
            .disposed(by: disposeBag)
        
        addMemberView
            .button.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.nextTapped()
            })
            .disposed(by: disposeBag)
        
        viewModel
            .step()
            .drive(onNext: { [weak self] step in
                self?.step(at: step)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension AddMemberViewController {
    static func make(transition: Transition) -> AddMemberViewController {
        let vc = AddMemberViewController(transition: transition)
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
}

// MARK: Private
private extension AddMemberViewController {
    func disableMembersUnits(_ units: [MemberUnit]) {
        units.forEach { unit in
            switch unit {
            case .me:
                addMemberView.memberUnitView.meUnitCell.state = .disabled
            case .child:
                addMemberView.memberUnitView.childUnitCell.state = .disabled
            case .parent:
                addMemberView.memberUnitView.parentUnitCell.state = .disabled
            case .other:
                addMemberView.memberUnitView.otherUnitCell.state = .disabled
            }
        }
    }
    
    func addMemberUnitActions() {
        let meGesture = UITapGestureRecognizer()
        addMemberView.memberUnitView.meUnitCell.addGestureRecognizer(meGesture)
        addMemberView.memberUnitView.meUnitCell.isUserInteractionEnabled = true
        
        let childGesture = UITapGestureRecognizer()
        addMemberView.memberUnitView.childUnitCell.addGestureRecognizer(childGesture)
        addMemberView.memberUnitView.childUnitCell.isUserInteractionEnabled = true
        
        let parentGesture = UITapGestureRecognizer()
        addMemberView.memberUnitView.parentUnitCell.addGestureRecognizer(parentGesture)
        addMemberView.memberUnitView.parentUnitCell.isUserInteractionEnabled = true
        
        let otherGesture = UITapGestureRecognizer()
        addMemberView.memberUnitView.otherUnitCell.addGestureRecognizer(otherGesture)
        addMemberView.memberUnitView.otherUnitCell.isUserInteractionEnabled = true
        
        Observable
            .merge([
                meGesture.rx.event.map { _ in MemberUnit.me },
                childGesture.rx.event.map { _ in MemberUnit.child },
                parentGesture.rx.event.map { _ in MemberUnit.parent },
                otherGesture.rx.event.map { _ in MemberUnit.other },
            ])
            .subscribe(onNext: { [weak self] unit in
                self?.update(checked: unit)
                self?.viewModel.selectMemberUnit.accept(unit)
            })
            .disposed(by: disposeBag)
    }
    
    func update(checked memberUnit: MemberUnit) {
        [
            addMemberView.memberUnitView.meUnitCell,
            addMemberView.memberUnitView.childUnitCell,
            addMemberView.memberUnitView.parentUnitCell,
            addMemberView.memberUnitView.otherUnitCell
        ]
        .filter { $0.state != .disabled }
        .forEach {
            $0.state = .unchecked
        }
        
        switch memberUnit {
        case .me:
            addMemberView.memberUnitView.meUnitCell.state = .checked
        case .child:
            addMemberView.memberUnitView.childUnitCell.state = .checked
        case .parent:
            addMemberView.memberUnitView.parentUnitCell.state = .checked
        case .other:
            addMemberView.memberUnitView.otherUnitCell.state = .checked
        }
    }
    
    func addTemperatureUnitActions() {
        let fahrenheidGesture = UITapGestureRecognizer()
        addMemberView.temperatureUnitView.fahrenheitCell.addGestureRecognizer(fahrenheidGesture)
        addMemberView.temperatureUnitView.fahrenheitCell.isUserInteractionEnabled = true
        
        let celsiusGesture = UITapGestureRecognizer()
        addMemberView.temperatureUnitView.celsiusCell.addGestureRecognizer(celsiusGesture)
        addMemberView.temperatureUnitView.celsiusCell.isUserInteractionEnabled = true
        
        Observable
            .merge([
                fahrenheidGesture.rx.event.map { _ in TemperatureUnit.fahrenheit },
                celsiusGesture.rx.event.map { _ in TemperatureUnit.celsius },
            ])
            .subscribe(onNext: { [weak self] unit in
                self?.update(checked: unit)
                self?.viewModel.selectTemperatureUnit.accept(unit)
            })
            .disposed(by: disposeBag)
    }
    
    func update(checked temperatureUnit: TemperatureUnit) {
        [
            addMemberView.temperatureUnitView.fahrenheitCell,
            addMemberView.temperatureUnitView.celsiusCell
        ]
        .filter { $0.state != .disabled }
        .forEach {
            $0.state = .unchecked
        }
        
        switch temperatureUnit {
        case .fahrenheit:
            addMemberView.temperatureUnitView.fahrenheitCell.state = .checked
        case .celsius:
            addMemberView.temperatureUnitView.celsiusCell.state = .checked
        }
    }
    
    func nextTapped() {
        guard canNext() else {
            return
        }
        
        let nextStepIndex = addMemberView.step.rawValue + 1
        
        guard let nextStep = AddMemberView.Step(rawValue: nextStepIndex) else {
            viewModel.addMember.accept(Void())
            
            return
        }
        
        addMemberView.step = nextStep
    }
    
    func canNext() -> Bool {
        switch addMemberView.step {
        case .memberUnitView:
            return hasCheckedMemberUnit()
        case .temperatureUnitView:
            return hasCheckedTemperatureUnit()
        }
    }
    
    func hasCheckedMemberUnit() -> Bool {
        [
            addMemberView.memberUnitView.meUnitCell,
            addMemberView.memberUnitView.childUnitCell,
            addMemberView.memberUnitView.parentUnitCell,
            addMemberView.memberUnitView.otherUnitCell
        ]
        .contains(where: { $0.state == .checked })
    }
    
    func hasCheckedTemperatureUnit() -> Bool {
        [
            addMemberView.temperatureUnitView.fahrenheitCell,
            addMemberView.temperatureUnitView.celsiusCell
        ]
        .contains(where: { $0.state == .checked })
    }
    
    func step(at step: AddMemberViewModel.Step) {
        switch step {
        case .added:
            closed()
        case .error(let message):
            Toast.notify(with: message, style: .danger)
        }
    }
    
    func closed() {
        switch transition {
        case .push:
            navigationController?.popViewController(animated: true)
        case .present:
            dismiss(animated: true)
        case .root:
            UIApplication.shared.keyWindow?.rootViewController = MainViewController.make()
        }
    }
}
