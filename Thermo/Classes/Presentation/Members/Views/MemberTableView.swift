//
//  MemberTableView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 29.10.2020.
//

import UIKit

final class MemberTableView: UITableView {
    var didSelectMember: ((Member) -> Void)?
    
    private var elements = [Member]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension MemberTableView {
    func setup(elements: [Member]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDelegate
extension MemberTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        14.scale
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectMember?(elements[indexPath.section])
    }
}

// MARK: UITableViewDataSource
extension MemberTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: MemberTableCell.self)) as! MemberTableCell
        cell.setup(member: elements[indexPath.section])
        return cell
    }
}

// MARK: Private
private extension MemberTableView {
    func configure() {
        register(MemberTableCell.self, forCellReuseIdentifier: String(describing: MemberTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
