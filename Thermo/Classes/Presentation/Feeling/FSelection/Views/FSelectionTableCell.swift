//
//  SymptomsTableCell.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 06.02.2021.
//

import UIKit

final class FSelectionTableCell: UITableViewCell {
    lazy var checkedView = makeCheckedView()
    lazy var label = makeLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension FSelectionTableCell {
    func setup(element: FSelectionTableElement) {
        checkedView.backgroundColor = element.isSelected ? UIColor(integralRed: 148, green: 165, blue: 225) : UIColor(integralRed: 233, green: 233, blue: 234)
        
        let attrs = TextAttributes()
            .font(Fonts.Poppins.regular(size: 16.scale))
            .lineHeight(20.scale)
            .textColor(element.isSelected ? UIColor(integralRed: 148, green: 165, blue: 225) : UIColor(integralRed: 63, green: 63, blue: 86))
        label.attributedText = element.name.attributed(with: attrs)
    }
}

// MARK: Private
private extension FSelectionTableCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension FSelectionTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            checkedView.widthAnchor.constraint(equalToConstant: 20.scale),
            checkedView.heightAnchor.constraint(equalToConstant: 20.scale),
            checkedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.scale),
            checkedView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40.scale),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14.scale),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension FSelectionTableCell {
    func makeCheckedView() -> CircleView {
        let view = CircleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
