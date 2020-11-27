//
//  OnboardingViewModel.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 26.10.2020.
//

import RxSwift
import RxCocoa

final class OnboardingViewModel {
    private let monetizationManager = MonetizationManagerCore()
    
    func needPayment() -> Bool {
        monetizationManager.getMonetizationConfig()?.afterOnboarding ?? false
    }
}
