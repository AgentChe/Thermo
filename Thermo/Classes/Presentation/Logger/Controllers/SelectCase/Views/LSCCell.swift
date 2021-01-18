//
//  LSCCell.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 18.01.2021.
//

import UIKit

final class LSCCell: UIView {
    lazy var checkedView = makeCheckedView()
    lazy var iconView = makeIconView()
    lazy var label = makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension LSCCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            checkedView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26.scale),
            checkedView.widthAnchor.constraint(equalToConstant: 20.scale),
            checkedView.heightAnchor.constraint(equalToConstant: 20.scale),
            checkedView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 61.scale),
            iconView.widthAnchor.constraint(equalToConstant: 25.scale),
            iconView.heightAnchor.constraint(equalToConstant: 25.scale),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 96.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.scale),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension LSCCell {
    func makeCheckedView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
