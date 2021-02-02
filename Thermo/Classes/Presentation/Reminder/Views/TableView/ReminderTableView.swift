//
//  ReminderTableView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 01.11.2020.
//

import UIKit

final class ReminderTableView: UITableView {
    private var sections = [ReminderTableSection]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension ReminderTableView {
    func setup(sections: [ReminderTableSection]) {
        self.sections = sections
        
        reloadData()
    }
}

// MARK: UITableViewDelegate
extension ReminderTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50.scale
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = PaddingLabel()
        view.leftInset = 24.scale
        view.rightInset = 24.scale
        view.attributedText = sections[section].title
        view.backgroundColor = UIColor.clear
        view.numberOfLines = 0
        return view
    }
}

// MARK: UITableViewDataSource
extension ReminderTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let element = section.elements[indexPath.row]
        
        let cell = dequeueReusableCell(withIdentifier: String(describing: ReminderTableCell.self), for: indexPath) as! ReminderTableCell
        cell.setup(element: element)
        
        return cell
    }
}

// MARK: Private
private extension ReminderTableView {
    func configure() {
        register(ReminderTableCell.self, forCellReuseIdentifier: String(describing: ReminderTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
