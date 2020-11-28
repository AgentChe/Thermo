//
//  LoggerSelectionControllerView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.11.2020.
//

import UIKit

final class LoggerSelectionControllerView: GradientView {
    lazy var searchView = makeSearchView()
    lazy var tableView = makeTableView()
    
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
private extension LoggerSelectionControllerView {
    func configure() {
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        gradientLayer.colors = [
            UIColor(integralRed: 200, green: 0, blue: 100).cgColor,
            UIColor(integralRed: 100, green: 150, blue: 200).cgColor
        ]
    }
}

// MARK: Make constraints
private extension LoggerSelectionControllerView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            searchView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            searchView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            searchView.topAnchor.constraint(equalTo: topAnchor, constant: 94.scale),
            searchView.heightAnchor.constraint(equalToConstant: 48.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            tableView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 8.scale),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension LoggerSelectionControllerView {
    func makeSearchView() -> LSSearchView {
        let view = LSSearchView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 6.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> UITableView {
        let view = UITableView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 6.scale
        view.separatorStyle = .none
        view.register(LSTableTitleCell.self, forCellReuseIdentifier: String(describing: LSTableTitleCell.self))
        view.register(LSTableCheckCell.self, forCellReuseIdentifier: String(describing: LSTableCheckCell.self))
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
