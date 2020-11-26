//
//  AMStepMaker.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 26.11.2020.
//

final class AMStepMaker {
    enum Action {
        case navigateToStep(AddMemberView.Step)
        case finish
    }
    
    var selectedUnit: AMMemberUnit?
    
    private var lastStep: AddMemberView.Step
    
    init(initialStep: AddMemberView.Step) {
        lastStep = initialStep
    }
}

// MARK: API
extension AMStepMaker {
    func makeStep() -> Action? {
        guard let selectedUnit = self.selectedUnit else {
            return .navigateToStep(.memberUnitView)
        }
        
        switch selectedUnit {
        case .me, .child, .parent, .other:
            return incrementHumanStep()
        case .animal:
            return incrementAnimalStep()
        case .object:
            return incrementObjectStep()
        }
    }
    
    func steps() -> [AddMemberView.Step] {
        guard let selectedUnit = self.selectedUnit else {
            return [.memberUnitView, .genderView, .createProfileView, .dateBirthdayView, .temperatureUnitView]
        }
        
        switch selectedUnit {
        case .me, .child, .parent, .other:
            return [.memberUnitView, .genderView, .createProfileView, .dateBirthdayView, .temperatureUnitView]
        case .animal, .object:
            return [.memberUnitView, .createProfileView, .temperatureUnitView]
        }
    }
}

// MARK: Private
private extension AMStepMaker {
    func incrementHumanStep() -> Action? {
        switch lastStep {
        case .memberUnitView:
            lastStep = .genderView
            return .navigateToStep(.genderView)
        case .genderView:
            lastStep = .createProfileView
            return .navigateToStep(.createProfileView)
        case .createProfileView:
            lastStep = .dateBirthdayView
            return .navigateToStep(.dateBirthdayView)
        case .dateBirthdayView:
            lastStep = .temperatureUnitView
            return .navigateToStep(.temperatureUnitView)
        case .temperatureUnitView:
            lastStep = .memberUnitView
            return .finish
        }
    }
    
    func incrementAnimalStep() -> Action? {
        if lastStep == .memberUnitView {
            lastStep = .createProfileView
            return .navigateToStep(.createProfileView)
        } else if lastStep == .createProfileView {
            lastStep = .temperatureUnitView
            return .navigateToStep(.temperatureUnitView)
        } else if lastStep == .temperatureUnitView {
            lastStep = .memberUnitView
            return .finish
        }
        
        return nil
    }
    
    func incrementObjectStep() -> Action? {
        if lastStep == .memberUnitView {
            lastStep = .createProfileView
            return .navigateToStep(.createProfileView)
        } else if lastStep == .createProfileView {
            lastStep = .temperatureUnitView
            return .navigateToStep(.temperatureUnitView)
        } else if lastStep == .temperatureUnitView {
            lastStep = .memberUnitView
            return .finish
        }
        
        return nil
    }
}
