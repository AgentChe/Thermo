//
//  LSTableCheckCell.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.11.2020.
//

import UIKit

final class LSTableCheckCell: UITableViewCell {
    lazy var checkedBackgroundView = makeCheckedBackgroundView()
    lazy var checkImageView = makeCheckImageView()
    lazy var label = makeLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension LSTableCheckCell {
    func setup(isSelected: Bool, name: String) {
        checkedBackgroundView.isHidden = !isSelected
        
        let selectedCheckImage = UIImage(named: "TemperatureLogger.Feeiling.Select")
        let unselectedCheckImage = UIImage(named: "TemperatureLogger.Feeiling.Deselect")
        checkImageView.image = isSelected ? selectedCheckImage : unselectedCheckImage
        
        let selectedColor = UIColor(integralRed: 106, green: 121, blue: 248)
        let unselectedColor = UIColor.black
        label.attributedText = name
            .attributed(with: TextAttributes()
                            .textColor(isSelected ? selectedColor : unselectedColor)
                            .font(Fonts.Poppins.regular(size: 16.scale))
                            .lineHeight(20.scale))
    }
}

// MARK: Private
private extension LSTableCheckCell {
    func configure() {
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension LSTableCheckCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            checkedBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4.scale),
            checkedBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4.scale),
            checkedBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4.scale),
            checkedBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4.scale)
        ])
        
        NSLayoutConstraint.activate([
            checkImageView.widthAnchor.constraint(equalToConstant: 16.scale),
            checkImageView.heightAnchor.constraint(equalToConstant: 16.scale),
            checkImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12.scale),
            checkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 38.scale),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12.scale),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension LSTableCheckCell {
    func makeCheckedBackgroundView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 6.scale
        view.backgroundColor = UIColor(integralRed: 229, green: 231, blue: 250)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeCheckImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
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

