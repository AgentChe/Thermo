//
//  OnboardingViewModel.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 26.02.2021.
//

import RxSwift
import RxCocoa

final class OnboardingViewModel {
    private lazy var sessionManager = SessionManagerCore()
    private lazy var monetizationManager = MonetizationManagerCore()
    
    func needPayment() -> Bool {
        let hasActiveSubscription = sessionManager.getSession()?.activeSubscription ?? false
        let needPayment = monetizationManager.getMonetizationConfig()?.afterOnboarding ?? false
        
        if hasActiveSubscription {
            return false
        }
        
        return needPayment
    }
}
