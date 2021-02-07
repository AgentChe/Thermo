//
//  SymptomsTableView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 06.02.2021.
//

import UIKit

final class FSelectionTableView: UITableView {
    private lazy var elements = [FSelectionTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension FSelectionTableView {
    func setup(elements: [FSelectionTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension FSelectionTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: FSelectionTableCell.self)) as! FSelectionTableCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension FSelectionTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let element = elements[indexPath.row]
        element.isSelected = !element.isSelected
        
        let cell = tableView.cellForRow(at: indexPath) as? FSelectionTableCell
        
        cell?.setup(element: element)
    }
}

// MARK: Private
private extension FSelectionTableView {
    func initialize() {
        register(FSelectionTableCell.self, forCellReuseIdentifier: String(describing: FSelectionTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
