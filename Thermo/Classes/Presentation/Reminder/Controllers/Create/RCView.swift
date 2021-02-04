//
//  RCView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 04.02.2021.
//

import UIKit

final class RCView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension RCView {
    func initialize() {
        backgroundColor = UIColor(integralRed: 246, green: 246, blue: 246)
    }
}

// MARK: Make constraints
private extension RCView {
    
}

// MARK: Lazy initialization
private extension RCView {
    
}
