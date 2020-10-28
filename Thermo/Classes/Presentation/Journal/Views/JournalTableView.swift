//
//  JournalTableView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import UIKit

final class JournalTableView: UITableView {
    private var elements = [JournalTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension JournalTableView {
    func setup(elements: [JournalTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDelegate
extension JournalTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50.scale
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        14.scale
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
}

// MARK: UITableViewDataSource
extension JournalTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: JournalTableCell.self)) as! JournalTableCell
        cell.setup(element: elements[indexPath.section])
        return cell
    }
}

// MARK: Private
private extension JournalTableView {
    func configure() {
        register(JournalTableCell.self, forCellReuseIdentifier: String(describing: JournalTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
