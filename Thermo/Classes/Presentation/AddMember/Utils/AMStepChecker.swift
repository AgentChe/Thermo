//
//  AMNextStepChecker.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 26.11.2020.
//

import UIKit

final class AMStepChecker {
    var selectedUnit: AMMemberUnit?
    
    var foundNameOnCheck: ((String?) -> Void)?
    var foundDateBirthdayOnCheck: ((Date) -> Void)?
    
    private weak var vc: AddMemberViewController?
    
    init(vc: AddMemberViewController) {
        self.vc = vc
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
        
        guard let selectedUnit = self.selectedUnit else {
            return false
        }
        
        var name = vc.addMemberView.createProfileView.textField.text ?? ""
        if name.isEmpty {
            name = String(describing: selectedUnit)
        }
        
        foundNameOnCheck?(name)
        
        return true
    }
    
    func hasFilledDateBirthday() -> Bool {
        guard let vc = self.vc else {
            return false
        }
        
        foundDateBirthdayOnCheck?(vc.addMemberView.dateBirthdayView.datePicker.date)
        
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
