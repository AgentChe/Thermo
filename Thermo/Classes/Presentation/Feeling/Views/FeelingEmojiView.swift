//
//  FeelingEmojiView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 06.02.2021.
//

import UIKit

final class FeelingEmojiView: UIView {
    lazy var imageContainerView = makeImageContainer()
    lazy var imageView = makeImageView()
    lazy var checkedView = makeCheckedView()
    lazy var label = makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension FeelingEmojiView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageContainerView.widthAnchor.constraint(equalToConstant: 61.scale),
            imageContainerView.heightAnchor.constraint(equalToConstant: 61.scale),
            imageContainerView.topAnchor.constraint(equalTo: topAnchor),
            imageContainerView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 40.scale),
            imageView.heightAnchor.constraint(equalToConstant: 40.scale),
            imageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            checkedView.widthAnchor.constraint(equalToConstant: 20.scale),
            checkedView.heightAnchor.constraint(equalToConstant: 20.scale),
            checkedView.centerXAnchor.constraint(equalTo: imageContainerView.trailingAnchor, constant: -8.scale),
            checkedView.centerYAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension FeelingEmojiView {
    func makeImageContainer() -> CircleView {
        let view = CircleView()
        view.backgroundColor = UIColor(integralRed: 246, green: 246, blue: 246)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        imageContainerView.addSubview(view)
        return view
    }
    
    func makeCheckedView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Feeling.Checked")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.textColor = UIColor(integralRed: 83, green: 83, blue: 83)
        view.font = Fonts.Poppins.semiBold(size: 12.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
