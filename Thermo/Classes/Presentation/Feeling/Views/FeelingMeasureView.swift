//
//  FeelingMeasureView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 05.02.2021.
//

import UIKit

final class FeelingMeasureView: UIView {
    lazy var imageView = makeImageView()
    lazy var label = makeLabel()
    lazy var arrowView = makeArrowView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension FeelingMeasureView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 57.scale),
            imageView.heightAnchor.constraint(equalToConstant: 57.scale),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 97.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50.scale),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            arrowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30.scale),
            arrowView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension FeelingMeasureView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Feeling.Select")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 83, green: 83, blue: 83))
            .font(Fonts.Poppins.semiBold(size: 20.scale))
            .lineHeight(27.scale)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Feeling.MeasureMyTemperature".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeArrowView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Feeling.Arrow")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
