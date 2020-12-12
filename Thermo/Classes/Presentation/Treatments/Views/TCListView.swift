//
//  TCListView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 02.12.2020.
//

import UIKit

final class TCListView: UIView {
    var tapped: ((Int) -> Void)?
    
    var conditions = [TreatmentCondition]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var titleLabel = makeTitleLabel()
    lazy var desclaimerView = makeDesclaimerView()
    lazy var tableView = makeTableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UITableViewDataSource
extension TCListView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        conditions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TCListCell.self), for: indexPath) as! TCListCell
        cell.setup(condition: conditions[indexPath.section])
        return cell
    }
}

// MARK: UITableViewDelegate
extension TCListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80.scale
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        19.scale
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tapped?(indexPath.section)
    }
}

// MARK: Make constraints
private extension TCListView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 100.scale : 60.scale)
        ])
        
        NSLayoutConstraint.activate([
            desclaimerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            desclaimerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            desclaimerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 30.scale : 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            tableView.topAnchor.constraint(equalTo: desclaimerView.bottomAnchor, constant: 18.scale),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -29.scale : -12.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TCListView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.Poppins.bold(size: 34.scale))
            .lineHeight(41.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Treatments.List.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDesclaimerView() -> TCDisclaimerView {
        let view = TCDisclaimerView()
        view.backgroundColor = UIColor(integralRed: 252, green: 242, blue: 250)
        view.layer.cornerRadius = 4.scale
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = UIColor(integralRed: 241, green: 223, blue: 238).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> UITableView {
        let view = UITableView()
        view.register(TCListCell.self, forCellReuseIdentifier: String(describing: TCListCell.self))
        view.dataSource = self
        view.delegate = self
        view.showsVerticalScrollIndicator = false
        view.separatorStyle = .none
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
