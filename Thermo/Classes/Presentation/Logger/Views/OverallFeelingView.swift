//
//  OverallFeelingView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import UIKit

final class OverallFeelingView: GradientView {
    lazy var titleLabel = makeTitleLabel()
    lazy var badItem = makeItem(image: "TemperatureLogger.Feeiling.Bad")
    lazy var mehItem = makeItem(image: "TemperatureLogger.Feeiling.Meh")
    lazy var goodItem = makeItem(image: "TemperatureLogger.Feeiling.Good")
    lazy var scrollView = makeScrollView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private s
private extension OverallFeelingView {
    func configure() {
        badItem.frame.origin = CGPoint(x: 0, y: 0)
        mehItem.frame.origin = CGPoint(x: 120.scale, y: 0)
        goodItem.frame.origin = CGPoint(x: 240.scale, y: 0)
        
        scrollView.contentSize = CGSize(width: 340.scale, height: 100.scale)
    }
}

// MARK: Make constraints
private extension OverallFeelingView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 289.scale : 180.scale)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30.scale),
            scrollView.heightAnchor.constraint(equalToConstant: 100.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OverallFeelingView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.OpenSans.bold(size: 34.scale))
            .textAlignment(.center)
            .lineHeight(41.scale)
    
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "TemperatureLogger.Feeling.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeItem(image: String) -> UIView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let view = CircleView()
        view.frame.size = CGSize(width: 100.scale, height: 100.scale)
        view.addSubview(imageView)
        view.backgroundColor = UIColor.white
        scrollView.addSubview(view)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 60.scale),
            imageView.heightAnchor.constraint(equalToConstant: 40.scale),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }
    
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.backgroundColor = UIColor.clear
        view.contentInset = UIEdgeInsets(top: 0, left: 40.scale, bottom: 0, right: 40.scale)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
