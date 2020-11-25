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
    
    private lazy var imagePicker = ImagePicker(presentationController: self, delegate: self)
    
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
        addGenderActions()
        addTemperatureUnitActions()
        addCreateProfileActions()
        
        viewModel
            .existingMembersUnits()
            .drive(onNext: { [weak self] units in
                self?.existingMembersUnits(units)
            })
            .disposed(by: disposeBag)
        
        Observable
            .merge([
                addMemberView.button.rx.tap.asObservable(),
                addMemberView.dateBirthdayView.dialogButton.rx.tap.asObservable()
            ])
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

// MARK: ImagePickerDelegate
extension AddMemberViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        addMemberView.createProfileView.image = image
        
        guard let img = image else {
            return
        }
        
        viewModel
            .store(image: img)
            .drive(onNext: { [weak self] key in
                self?.viewModel.createImageKey.accept(key)
                self?.addMemberView.createProfileView.image = img
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Private
private extension AddMemberViewController {
    func existingMembersUnits(_ units: [MemberUnit]) {
        if units.contains(.me) {
            addMemberView.memberUnitView.meUnitCell.state = .disabled
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
                self?.addMemberView.genderView.setup(with: unit)
                self?.addMemberView.dateBirthdayView.setup(with: unit)
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
    
    func addGenderActions() {
        let maleGesture = UITapGestureRecognizer()
        addMemberView.genderView.maleCell.addGestureRecognizer(maleGesture)
        addMemberView.genderView.maleCell.isUserInteractionEnabled = true
        
        let femaleGesture = UITapGestureRecognizer()
        addMemberView.genderView.femaleCell.addGestureRecognizer(femaleGesture)
        addMemberView.genderView.femaleCell.isUserInteractionEnabled = true
        
        Observable
            .merge([
                maleGesture.rx.event.map { _ in Gender.male },
                femaleGesture.rx.event.map { _ in Gender.female },
            ])
            .subscribe(onNext: { [weak self] gender in
                self?.update(checked: gender)
                self?.viewModel.selectGender.accept(gender)
            })
            .disposed(by: disposeBag)
    }
    
    func update(checked gender: Gender) {
        [
            addMemberView.genderView.maleCell,
            addMemberView.genderView.femaleCell,
        ]
        .filter { $0.state != .disabled }
        .forEach {
            $0.state = .unchecked
        }
        
        switch gender {
        case .male:
            addMemberView.genderView.maleCell.state = .checked
        case .female:
            addMemberView.genderView.femaleCell.state = .checked
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
    
    func addCreateProfileActions() {
        let openImagePickerTapGesture = UITapGestureRecognizer()
        
        addMemberView.createProfileView.plusView.isUserInteractionEnabled = true
        addMemberView.createProfileView.plusView.addGestureRecognizer(openImagePickerTapGesture)
        
        openImagePickerTapGesture.rx.event
            .subscribe(onNext: { [weak self] event in
                guard let this = self else {
                    return
                }
                
                this.imagePicker.present(from: this.view)
            })
            .disposed(by: disposeBag)
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
        case .createProfileView:
            return hasFilledProfile()
        case .dateBirthdayView:
            return hasFilledDateBirthday()
        case .genderView:
            return hasCheckedGender()
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
    
    func hasFilledProfile() -> Bool {
        let canNext = addMemberView.createProfileView.textField.text?.isEmpty == false
            && addMemberView.createProfileView.image != nil
        
        if canNext {
            viewModel.inputName.accept(addMemberView.createProfileView.textField.text ?? "")
        }
        
        return canNext
    }
    
    func hasFilledDateBirthday() -> Bool {
        let selectedDate = addMemberView.dateBirthdayView.datePicker.date
        
        viewModel.inputDateBirthday.accept(selectedDate)
        
        return true
    }
    
    func hasCheckedGender() -> Bool {
        [
            addMemberView.genderView.maleCell,
            addMemberView.genderView.femaleCell
        ]
        .contains(where: { $0.state == .checked })
    }
    
    func step(at step: AddMemberViewModel.Step) {
        switch step {
        case .added:
            closed()
        case .error(let message):
            Toast.notify(with: message, style: .danger)
        case .paygate:
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        }
    }
    
    func closed() {
        switch transition {
        case .push:
            navigationController?.popViewController(animated: true)
        case .present:
            dismiss(animated: true)
        case .root:
            let vc = ThermoNavigationController(rootViewController: MainViewController.make())
            UIApplication.shared.keyWindow?.rootViewController = vc
        }
    }
}
