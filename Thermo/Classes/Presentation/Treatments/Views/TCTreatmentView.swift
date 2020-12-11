//
//  TCTreatmentView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 02.12.2020.
//

import UIKit

final class TCTreatmentView: GradientView {
    lazy var titleLabel = makeTitleLabel()
    lazy var imageView = makeImageView()
    lazy var textView = makeTextView()
    
    var html: String? {
        didSet {
            guard let value = html else {
                textView.text = ""
                
                return
            }
            
            textView.attributedText = HTMLString(string: value).htmlAttributedString
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension TCTreatmentView {
    func configure() {
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        gradientLayer.colors = [
            UIColor(integralRed: 211, green: 106, blue: 143).cgColor,
            UIColor(integralRed: 174, green: 108, blue: 199).cgColor,
        ]
    }
}

// MARK: Make constraints
private extension TCTreatmentView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: ScreenSize.isIphoneXFamily ? -30.scale : -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 191.scale : 150.scale),
            imageView.heightAnchor.constraint(equalToConstant: 103.57.scale)
        ])
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scale),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            textView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 318.57.scale : 270.scale),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TCTreatmentView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.Poppins.bold(size: 34.scale))
            .lineHeight(41.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Treatments.Treatment.Title".localized.attributed(with: attrs)
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Treatments.Header")
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextView() -> UITextView {
        let view = UITextView()
        view.isEditable = false 
        view.showsVerticalScrollIndicator = true
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}