//
//  AMCreateProfileView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 04.11.2020.
//

import UIKit
import RxSwift

final class AMCreateProfileView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var imageView = makeImageView()
    lazy var placeholderImageView = makePlaceholderImageView()
    lazy var plusView = makePlusView()
    lazy var textField = makeTextField()
    
    var image: UIImage? {
        didSet {
            updateImage()
        }
    }
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension AMCreateProfileView {
    func configure() {
        let hideKeyboardGesture = UITapGestureRecognizer()
        hideKeyboardGesture.rx.event
            .map { event in Void() }
            .bind(to: rx.hideKeyboardObserver)
            .disposed(by: disposeBag)
        addGestureRecognizer(hideKeyboardGesture)
        isUserInteractionEnabled = true
    }
    
    func updateImage() {
        guard let image = self.image else {
            return
        }
        
        placeholderImageView.isHidden = true
        imageView.image = image
    }
}

// MARK: Make constraints
private extension AMCreateProfileView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 120.scale : 60.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 110.scale),
            imageView.heightAnchor.constraint(equalToConstant: 110.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 270.scale : 190.scale)
        ])
        
        NSLayoutConstraint.activate([
            placeholderImageView.widthAnchor.constraint(equalToConstant: 42.scale),
            placeholderImageView.heightAnchor.constraint(equalToConstant: 42.scale),
            placeholderImageView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            placeholderImageView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            plusView.widthAnchor.constraint(equalToConstant: 31.scale),
            plusView.heightAnchor.constraint(equalToConstant: 31.scale),
            plusView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -8.scale),
            plusView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35.scale),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -35.scale),
            textField.heightAnchor.constraint(equalToConstant: 52.scale),
            textField.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 449.scale : 360.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension AMCreateProfileView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.OpenSans.bold(size: 34.scale))
            .lineHeight(41.scale)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "AddMember.CreateProfile.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 55.scale
        view.clipsToBounds = true
        view.backgroundColor = UIColor(integralRed: 243, green: 243, blue: 243)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePlaceholderImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "AddMember.CreateProfile.Profile")
        view.clipsToBounds = true
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(view)
        return view
    }
    
    func makePlusView() -> UIView {
        let view = UIView()
        view.layer.borderWidth = 2.scale
        view.layer.borderColor = UIColor(integralRed: 211, green: 199, blue: 212).cgColor
        view.layer.cornerRadius = 15.5.scale
        view.backgroundColor = UIColor(integralRed: 238, green: 237, blue: 239)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "AddMember.CreateProfile.Add")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 15.scale),
            imageView.heightAnchor.constraint(equalToConstant: 15.scale),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }
    
    func makeTextField() -> UITextField {
        let view = UITextField()
        view.autocorrectionType = .no
        view.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        view.layer.borderWidth = 2.scale
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 16.scale
        view.placeholder = "AddMember.CreateProfile.Placeholder".localized
        view.textColor = UIColor(integralRed: 74, green: 71, blue: 73)
        view.font = Fonts.Poppins.semiBold(size: 17.scale)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
