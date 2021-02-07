//
//  RCCell.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 06.02.2021.
//

import UIKit

final class RCCell: UIView {
    lazy var label = makeLabel()
    lazy var checkedView = makeCheckedView()
    
    lazy var isChecked = false {
        didSet {
            update()
        }
    }
    
    let weekday: Weekday
    
    init(weekday: Weekday) {
        self.weekday = weekday
        
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension RCCell {
    func update() {
        checkedView.backgroundColor = isChecked ? UIColor(integralRed: 148, green: 164, blue: 225) : UIColor(integralRed: 233, green: 233, blue: 234)
    }
}

// MARK: Make constraints
private extension RCCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30.scale),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            checkedView.widthAnchor.constraint(equalToConstant: 23.scale),
            checkedView.heightAnchor.constraint(equalToConstant: 23.scale),
            checkedView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30.scale),
            checkedView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension RCCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.font = Fonts.Poppins.regular(size: 20.scale)
        view.textColor = UIColor(integralRed: 50, green: 50, blue: 52)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCheckedView() -> CircleView {
        let view = CircleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
