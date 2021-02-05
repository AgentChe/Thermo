//
//  RLTableView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 04.02.2021.
//

import UIKit

final class RLTableView: UITableView {
    var didRemove: ((RLTableElement) -> Void)?
    
    private lazy var elements = [RLTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension RLTableView {
    func setup(elements: [RLTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension RLTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: RLTableCell.self)) as! RLTableCell
        cell.setup(element: elements[indexPath.section])
        return cell
    }
}

// MARK: UITableViewDelegate
extension RLTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        26.scale
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        124.scale
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, completionHandler) in
            guard let this = self else {
                return
            }
            
            this.didRemove?(this.elements[indexPath.section])
            
            this.elements.remove(at: indexPath.section)
            this.deleteSections([indexPath.section], with: .fade)
            
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(named: "Reminder.List.Delete")
        deleteAction.backgroundColor = UIColor(integralRed: 246, green: 246, blue: 246)
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}

// MARK: Private
private extension RLTableView {
    func initialize() {
        register(RLTableCell.self, forCellReuseIdentifier: String(describing: RLTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
