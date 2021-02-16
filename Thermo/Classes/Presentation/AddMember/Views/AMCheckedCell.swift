//
//  AMCheckedCell.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 02.02.2021.
//

import UIKit

final class AMCheckedCell: UIView {
    lazy var label = makeLabel()
    
    lazy var isSelected = false {
        didSet {
            update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension AMCheckedCell {
    func initialize() {
        layer.cornerRadius = 16.scale
        layer.masksToBounds = true
    }
    
    func update() {
        label.textColor = isSelected ? UIColor.white : UIColor(integralRed: 74, green: 71, blue: 73)
        backgroundColor = isSelected ? UIColor(integralRed: 148, green: 165, blue: 225) : UIColor(integralRed: 246, green: 246, blue: 246)
    }
}

// MARK: Make constraints
private extension AMCheckedCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15.scale),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension AMCheckedCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
