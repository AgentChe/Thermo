//
//  AMNextStepChecker.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 26.11.2020.
//

import UIKit
import RxCocoa

final class AMStepChecker {
    private weak var vc: AddMemberViewController?
    private let viewModel: AddMemberViewModel
    
    var selectedUnit: AMMemberUnit?
    
    init(vc: AddMemberViewController, viewModel: AddMemberViewModel) {
        self.vc = vc
        self.viewModel = viewModel
    }
}

// MARK: API
extension AMStepChecker {
    func canNext() -> Bool {
        guard let vc = self.vc else {
            return false
        }
        
        switch vc.addMemberView.step {
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
}

// MARK: Private
private extension AMStepChecker {
    func hasCheckedMemberUnit() -> Bool {
        guard let vc = self.vc else {
            return false
        }
        
        return [
            vc.addMemberView.memberUnitView.meUnitCell,
            vc.addMemberView.memberUnitView.childUnitCell,
            vc.addMemberView.memberUnitView.parentUnitCell,
            vc.addMemberView.memberUnitView.otherUnitCell,
            vc.addMemberView.memberUnitView.animalsUnitCell,
            vc.addMemberView.memberUnitView.objectsUnitCell
        ]
        .contains(where: { $0.state == .checked })
    }
    
    func hasCheckedTemperatureUnit() -> Bool {
        guard let vc = self.vc else {
            return false
        }
        
        return [
            vc.addMemberView.temperatureUnitView.fahrenheitCell,
            vc.addMemberView.temperatureUnitView.celsiusCell
        ]
        .contains(where: { $0.state == .checked })
    }
    
    func hasFilledProfile() -> Bool {
        guard let vc = self.vc else {
            return false
        }
        
        let isEmptyName = vc.addMemberView.createProfileView.textField.text?.isEmpty ?? true
        let isEmptyImage = vc.addMemberView.createProfileView.image == nil
        
        guard let selectedUnit = self.selectedUnit else {
            return false
        }
        
        let canNext: Bool
        switch selectedUnit {
        case .me, .parent, .child, .other:
            canNext = !isEmptyName && !isEmptyImage
        case .animal, .object:
            canNext = !isEmptyName
        }
        
        if canNext {
            viewModel.inputName.accept(vc.addMemberView.createProfileView.textField.text ?? "")
        }
        
        return canNext
    }
    
    func hasFilledDateBirthday() -> Bool {
        guard let vc = self.vc else {
            return false
        }
        
        let selectedDate = vc.addMemberView.dateBirthdayView.datePicker.date
        viewModel.inputDateBirthday.accept(selectedDate)
        
        return true
    }
    
    func hasCheckedGender() -> Bool {
        guard let vc = self.vc else {
            return false
        }
        
        return [
            vc.addMemberView.genderView.maleCell,
            vc.addMemberView.genderView.femaleCell
        ]
        .contains(where: { $0.state == .checked })
    }
}
