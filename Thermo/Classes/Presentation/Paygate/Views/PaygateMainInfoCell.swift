//
//  PaygateMainInfoCell.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 25.11.2020.
//

import UIKit

final class PaygateMainInfoCell: UIView {
    lazy var iconView = makeIconView()
    lazy var label = makeLabel()
    
    var title: String = "" {
        didSet {
            label.attributedText = title
                .attributed(with: TextAttributes()
                                .textColor(UIColor.black)
                                .font(Fonts.Poppins.semiBold(size: 17.scale))
                                .lineHeight(20.scale))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension PaygateMainInfoCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 13.scale),
            iconView.heightAnchor.constraint(equalToConstant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 23.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.scale),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension PaygateMainInfoCell {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Paygate.Main.CellIcon")
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
