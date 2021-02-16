//
//  FeelingHeaderView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 05.02.2021.
//

import UIKit

final class FeelingHeaderView: UIView {
    lazy var image1View = makeImage1View()
    lazy var image2View = makeImage2View()
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
private extension FeelingHeaderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            image1View.leadingAnchor.constraint(equalTo: leadingAnchor),
            image1View.trailingAnchor.constraint(equalTo: trailingAnchor),
            image1View.topAnchor.constraint(equalTo: topAnchor),
            image1View.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            image2View.widthAnchor.constraint(equalToConstant: 60.scale),
            image2View.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 178.scale : 140.scale),
            image2View.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            image2View.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 63.scale : 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -108.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 103.scale : 70.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension FeelingHeaderView {
    func makeImage1View() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "Feeling.Header1")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImage2View() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Feeling.Header2")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.Poppins.bold(size: 25.scale))
            .lineHeight(33.scale)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Feeling.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
