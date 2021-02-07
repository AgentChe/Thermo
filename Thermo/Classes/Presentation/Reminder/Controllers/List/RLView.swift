//
//  RLView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 04.02.2021.
//

import UIKit

final class RLView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var tableView = makeTableView()
    lazy var emptyView = makeEmptyView()
    lazy var addButton = makeAddButton()
    
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
private extension RLView {
    func initialize() {
        backgroundColor = UIColor(integralRed: 246, green: 246, blue: 246)
    }
}

// MARK: Make constraints
private extension RLView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 85.scale : 40.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emptyView.centerYAnchor.constraint(equalTo: centerYAnchor),
            emptyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: 50.scale),
            addButton.heightAnchor.constraint(equalToConstant: 50.scale),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            addButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -13.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension RLView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 50, green: 50, blue: 52))
            .font(Fonts.Poppins.bold(size: 30.scale))
            .lineHeight(34.scale)
        
        let view = UILabel()
        view.attributedText = "Reminder.List.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> RLTableView {
        let view = RLTableView()
        view.backgroundColor = UIColor.clear
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeEmptyView() -> RLEmptyView {
        let view = RLEmptyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAddButton() -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: "Reminder.List.Add"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
