//
//  TCPreloaderView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 02.12.2020.
//

import UIKit

final class TCPreloaderView: UIView {
    lazy var imageView = makeImageView()
    lazy var label = makeLabel()
    
    private var animateLayer: CABasicAnimation?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension TCPreloaderView {
    func startAnimate() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = 2
        rotateAnimation.repeatCount = Float.infinity
        imageView.layer.add(rotateAnimation, forKey: nil)
        
        animateLayer = rotateAnimation
    }
    
    func stopAnimate() {
        imageView.layer.removeAllAnimations()
        animateLayer = nil
    }
}

// MARK: Make constraints
private extension TCPreloaderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 310.scale : 210.scale),
            imageView.heightAnchor.constraint(equalToConstant: 118.85.scale),
            imageView.widthAnchor.constraint(equalToConstant: 133.33.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 461.scale : 361.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TCPreloaderView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Treatments.Preloader")
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.Poppins.semiBold(size: 24.scale))
            .lineHeight(41.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Treatments.Preloader".localized.attributed(with: attrs)
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
