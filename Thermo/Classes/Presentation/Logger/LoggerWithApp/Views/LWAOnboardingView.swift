//
//  LWAOnboardingView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 05.02.2021.
//

import UIKit

final class LWAOnboardingView: UIView {
    lazy var button = makeButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension LWAOnboardingView {
    func initialize() {
        backgroundColor = UIColor.white
    }
}

// MARK: Make constraints
private extension LWAOnboardingView {
    func makeConstraints() {
        
    }
}

// MARK: Lazy initialization
private extension LWAOnboardingView {
    func makeButton() -> UIButton {
        let view = UIButton()
        return view
    }
}
