//
//  LWAMeasurementView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 05.02.2021.
//

import UIKit

final class LWAMeasurementView: UIView {
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
private extension LWAMeasurementView {
    func initialize() {
        backgroundColor = UIColor.white
    }
}

// MARK: Make constraints
private extension LWAMeasurementView {
    func makeConstraints() {
        
    }
}

// MARK: Lazy initialization
private extension LWAMeasurementView {
    
}
