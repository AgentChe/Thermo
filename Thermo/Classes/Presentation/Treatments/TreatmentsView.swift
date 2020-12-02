//
//  TreatmentsView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 02.12.2020.
//

import UIKit

final class TreatmentsView: GradientView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension TreatmentsView {
    func configure() {
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        gradientLayer.colors = [
            UIColor(integralRed: 211, green: 106, blue: 143).cgColor,
            UIColor(integralRed: 174, green: 108, blue: 199).cgColor,
        ]
    }
}

// MARK: Make constraints
private extension TreatmentsView {
    func makeConstraints() {
        
    }
}

// MARK: Lazy initialization
private extension TreatmentsView {
    
}
