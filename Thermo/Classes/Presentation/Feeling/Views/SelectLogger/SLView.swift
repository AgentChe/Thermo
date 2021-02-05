//
//  SLView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 06.02.2021.
//

import UIKit

final class SLView: UIView {
    lazy var tappedView = makeTappedView()
    lazy var container = makeContainer()
    lazy var titleLabel = makeTitleLabel()
    lazy var withAppCell = makeCell(text: "Feeling.SelectLogger.WithTheApp")
    lazy var manuallyCell = makeCell(text: "Feeling.SelectLogger.Manually")
    
    lazy var bottom = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension SLView {
    func initialize() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
}

// MARK: Make constraints
private extension SLView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            tappedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tappedView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tappedView.topAnchor.constraint(equalTo: topAnchor),
            tappedView.bottomAnchor.constraint(equalTo: container.topAnchor)
        ])
        
        bottom = container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 215.scale)
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.heightAnchor.constraint(equalToConstant: 215.scale),
            bottom
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 30.scale),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -30.scale),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            withAppCell.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            withAppCell.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            withAppCell.heightAnchor.constraint(equalToConstant: 48.scale),
            withAppCell.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            manuallyCell.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            manuallyCell.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            manuallyCell.heightAnchor.constraint(equalToConstant: 48.scale),
            manuallyCell.topAnchor.constraint(equalTo: withAppCell.bottomAnchor, constant: 10.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SLView {
    func makeTappedView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 33.scale
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 50, green: 50, blue: 52))
            .font(Fonts.Poppins.semiBold(size: 18.scale))
            .lineHeight(27.scale)
        
        let view = UILabel()
        view.attributedText = "Feeling.SelectLogger.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeCell(text: String) -> SLCell {
        let view = SLCell()
        view.label.text = text.localized
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
