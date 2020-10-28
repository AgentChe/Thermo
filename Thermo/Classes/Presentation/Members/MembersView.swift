//
//  MembersView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 29.10.2020.
//

import UIKit

final class MembersView: UIView {
    lazy var container = makeContainer()
    lazy var closeButton = makeCloseButton()
    lazy var addNewButton = makeAddNewButton()
    lazy var tableView = makeTableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension MembersView {
    func configure() {
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
}

// MARK: Make constraints
private extension MembersView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.heightAnchor.constraint(equalToConstant: 420.scale)
        ])
        
        NSLayoutConstraint.activate([
            addNewButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36.scale),
            addNewButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36.scale),
            addNewButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -27.scale),
            addNewButton.heightAnchor.constraint(equalToConstant: 56.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addNewButton.topAnchor),
            tableView.topAnchor.constraint(equalTo: container.topAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 30.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 30.scale),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36.scale),
            closeButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 24.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension MembersView {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(integralRed: 233, green: 233, blue: 233)
        view.layer.cornerRadius = 24.scale
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCloseButton() -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: "Members.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeAddNewButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.Poppins.semiBold(size: 17.scale))
            .lineHeight(22.scale)
        
        let view = UIButton()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 28.scale
        view.setAttributedTitle("Members.AddNew".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeTableView() -> MemberTableView {
        let view = MemberTableView()
        view.separatorStyle = .none
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
