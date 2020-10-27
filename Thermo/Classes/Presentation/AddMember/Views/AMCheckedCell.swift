//
//  AMCheckedCell.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.10.2020.
//

import UIKit

final class AMCheckedCell: UIView {
    enum State {
        case unchecked, checked, disabled
    }
    
    lazy var uncheckedView = makeUncheckedView()
    lazy var checkedView = makeCheckedView()
    lazy var label = makeLabel()
    
    var state = State.unchecked {
        didSet {
            update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension AMCheckedCell {
    func configure() {
        layer.cornerRadius = 16.scale
        
        update()
    }
    
    func update() {
        switch state {
        case .disabled:
            disabled()
        case .checked:
            checked()
        case .unchecked:
            unchecked()
        }
    }
    
    func disabled() {
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 0
        
        isUserInteractionEnabled = false
        alpha = 0.2
        
        backgroundColor = UIColor.white
        
        uncheckedView.isHidden = true
        checkedView.isHidden = false
    }
    
    func checked() {
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 0
        
        isUserInteractionEnabled = true
        alpha = 1
        
        backgroundColor = UIColor.white
        
        uncheckedView.isHidden = true
        checkedView.isHidden = false
    }
    
    func unchecked() {
        layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        layer.borderWidth = 2.scale
        
        isUserInteractionEnabled = true
        alpha = 1
        
        backgroundColor = UIColor.clear
        
        uncheckedView.isHidden = false
        checkedView.isHidden = true
    }
}

// MARK: Make constraints
private extension AMCheckedCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            uncheckedView.widthAnchor.constraint(equalToConstant: 20.scale),
            uncheckedView.heightAnchor.constraint(equalToConstant: 20.scale),
            uncheckedView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18.scale),
            uncheckedView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            checkedView.widthAnchor.constraint(equalToConstant: 28.scale),
            checkedView.heightAnchor.constraint(equalToConstant: 28.scale),
            checkedView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18.scale),
            checkedView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 15.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension AMCheckedCell {
    func makeUncheckedView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        view.layer.cornerRadius = 10.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCheckedView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "AddMember.MemberUnit.Checked")
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
