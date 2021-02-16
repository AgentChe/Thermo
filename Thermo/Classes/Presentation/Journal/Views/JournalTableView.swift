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

        initialize()
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
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        60.scale
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(integralRed: 246, green: 246, blue: 246)
        
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 189, green: 189, blue: 189))
            .font(Fonts.Poppins.regular(size: 17.scale))
            .lineHeight(27.scale)
            .letterSpacing(-0.4.scale)
        
        let label = UILabel()
        label.frame.origin = CGPoint(x: 30.scale, y: 25.scale)
        label.attributedText = sections[section].title.attributed(with: attrs)
        view.addSubview(label)
        
        label.sizeToFit()
        
        return view
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
        case .temperature(let temperature):
            let cell = dequeueReusableCell(withIdentifier: String(describing: JTTemperatureCell.self)) as! JTTemperatureCell
            cell.setup(temperature: temperature)
            return cell
        case .temperatureWithTags(let temperatureWithTags):
            let cell = dequeueReusableCell(withIdentifier: String(describing: JTTemperatureWithTagsCell.self)) as! JTTemperatureWithTagsCell
            cell.setup(temperatureWithTags: temperatureWithTags)
            return cell
        }
    }
}

// MARK: Private
private extension JournalTableView {
    func initialize() {
        register(JTTemperatureCell.self, forCellReuseIdentifier: String(describing: JTTemperatureCell.self))
        register(JTTemperatureWithTagsCell.self, forCellReuseIdentifier: String(describing: JTTemperatureWithTagsCell.self))

        dataSource = self
        delegate = self
    }
}
