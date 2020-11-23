//
//  JournalTableView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import UIKit

final class JournalTableView: UITableView {
    private var sections = [JournalTableSection]()
    
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
    func setup(sections: [JournalTableSection]) {
        self.sections = sections
        
        reloadData()
    }
}

// MARK: UITableViewDelegate
extension JournalTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section].elements[indexPath.row] {
        case .report:
            return 50.scale
        case .tags:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        14.scale
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cornerRadius = 11.scale

        let layer = CAShapeLayer()
        let pathRef = CGMutablePath()
        let bounds = cell.bounds.insetBy(dx: 16.scale, dy: 0)
        var addLine = false

        if indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            pathRef.__addRoundedRect(transform: nil, rect: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
        } else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            pathRef.move(to: .init(x: bounds.minX, y: bounds.minY))
            pathRef.addArc(tangent1End: .init(x: bounds.minX, y: bounds.maxY), tangent2End: .init(x: bounds.midX, y: bounds.maxY), radius: cornerRadius)
            pathRef.addArc(tangent1End: .init(x: bounds.maxX, y: bounds.maxY), tangent2End: .init(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
            pathRef.addLine(to: .init(x: bounds.maxX, y: bounds.minY))
        } else {
            pathRef.addRect(bounds)
            addLine = true
        }

        layer.path = pathRef
        layer.fillColor = UIColor(integralRed: 239, green: 239, blue: 244).cgColor

        if (addLine == true) {
            let lineLayer = CALayer()
            let lineHeight = 1.0 / UIScreen.main.scale
            lineLayer.frame = CGRect(x: bounds.minX, y: bounds.size.height - lineHeight, width: bounds.size.width, height: lineHeight)
            layer.addSublayer(lineLayer)
        }

        let testView = UIView(frame: bounds)
        testView.layer.insertSublayer(layer, at: 0)
        testView.backgroundColor = .clear
        cell.backgroundView = testView
    }
}

// MARK: UITableViewDataSource
extension JournalTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = sections[indexPath.section].elements[indexPath.row]
        
        switch element {
        case .report(let report):
            let cell = dequeueReusableCell(withIdentifier: String(describing: JournalTableCell.self)) as! JournalTableCell
            cell.setup(report: report)
            return cell
        case .tags(let tags):
            let cell = dequeueReusableCell(withIdentifier: String(describing: JournalTableTagsCell.self)) as! JournalTableTagsCell
            cell.setup(tags: tags)
            return cell
        }
    }
}

// MARK: Private
private extension JournalTableView {
    func configure() {
        register(JournalTableCell.self, forCellReuseIdentifier: String(describing: JournalTableCell.self))
        register(JournalTableTagsCell.self, forCellReuseIdentifier: String(describing: JournalTableTagsCell.self))
        
        dataSource = self
        delegate = self
    }
}
