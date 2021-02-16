//
//  SLCell.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 06.02.2021.
//

import UIKit

final class SLCell: UIView {
    lazy var label = makeLabel()
    lazy var imageView = makeImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension SLCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50.scale),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 16.scale),
            imageView.heightAnchor.constraint(equalToConstant: 8.scale),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SLCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.textColor = UIColor(integralRed: 97, green: 97, blue: 97)
        view.font = Fonts.Poppins.regular(size: 16.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "SL.Arrow")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
