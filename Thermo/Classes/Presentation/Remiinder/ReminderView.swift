//
//  ReminderView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import UIKit

final class ReminderView: UIView {
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

// MARK: Private
private extension ReminderView {
    func configure() {
        backgroundColor = UIColor.white
    }
}

// MARK: Make constraints
private extension ReminderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ReminderView {
    func makeTableView() -> ReminderTableView {
        let view = ReminderTableView(frame: .zero, style: .grouped)
        view.contentInset = UIEdgeInsets(top: 85.scale, left: 0, bottom: 0, right: 0)
        view.backgroundColor = UIColor.clear
        view.contentInsetAdjustmentBehavior = .never
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
