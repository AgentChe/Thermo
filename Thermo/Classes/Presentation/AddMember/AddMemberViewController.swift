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
    private lazy var stepChecker = AMStepChecker(vc: self, memberAttributiionsMaker: memberAttributiionsMaker)
    private lazy var memberAttributiionsMaker = AMMemberAttributionsMaker(vc: self)
    
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
                self?.memberAttributiionsMaker.imageKey = key
                self?.addMemberView.createProfileView.image = img
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Private
private extension AddMemberViewController {
    func existingMembersUnits(_ units: [AMMemberUnit]) {
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
        
        let animalsGesture = UITapGestureRecognizer()
        addMemberView.memberUnitView.animalsUnitCell.addGestureRecognizer(animalsGesture)
        addMemberView.memberUnitView.animalsUnitCell.isUserInteractionEnabled = true
        
        let objectsGesture = UITapGestureRecognizer()
        addMemberView.memberUnitView.objectsUnitCell.addGestureRecognizer(objectsGesture)
        addMemberView.memberUnitView.objectsUnitCell.isUserInteractionEnabled = true
        
        Observable
            .merge([
                meGesture.rx.event.map { event in AMMemberUnit.me },
                childGesture.rx.event.map { event in AMMemberUnit.child },
                parentGesture.rx.event.map { event in AMMemberUnit.parent },
                otherGesture.rx.event.map { event in AMMemberUnit.other },
                animalsGesture.rx.event.map { event in AMMemberUnit.animal },
                objectsGesture.rx.event.map { event in AMMemberUnit.object }
            ])
            .subscribe(onNext: { [weak self] unit in
                self?.update(checked: unit)
                self?.addMemberView.genderView.setup(with: unit)
                self?.addMemberView.dateBirthdayView.setup(with: unit)
                self?.addMemberView.createProfileView.style = AMCreateProfileStyleMaker.make(at: unit)
                self?.memberAttributiionsMaker.memberUnit = unit
                self?.stepChecker.selectedUnit = unit
            })
            .disposed(by: disposeBag)
    }
    
    func update(checked memberUnit: AMMemberUnit) {
        [
            addMemberView.memberUnitView.meUnitCell,
            addMemberView.memberUnitView.childUnitCell,
            addMemberView.memberUnitView.parentUnitCell,
            addMemberView.memberUnitView.otherUnitCell,
            addMemberView.memberUnitView.animalsUnitCell,
            addMemberView.memberUnitView.objectsUnitCell
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
        case .animal:
            addMemberView.memberUnitView.animalsUnitCell.state = .checked
        case .object:
            addMemberView.memberUnitView.objectsUnitCell.state = .checked
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
                self?.memberAttributiionsMaker.gender = gender
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
                self?.memberAttributiionsMaker.temperatureUnit = unit
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
        guard stepChecker.canNext() else {
            return
        }
        
        let nextStepIndex = addMemberView.step.rawValue + 1
        
        guard let nextStep = AddMemberView.Step(rawValue: nextStepIndex) else {
            if let attributions = memberAttributiionsMaker.makeAttributions() {
                viewModel.addMember.accept(attributions)
            }
            
            return
        }
        
        addMemberView.step = nextStep
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
