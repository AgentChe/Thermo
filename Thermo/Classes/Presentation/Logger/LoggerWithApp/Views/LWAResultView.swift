//
//  LWAResultView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 05.02.2021.
//

import UIKit

final class LWAResultView: UIView {
    
    lazy var button = makeButton()
    
    private lazy var stackView = makeStackView()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var subtitleLabel = makeSubtitleLabel()
    private lazy var imageView = makeResultImageView()
    private lazy var resultLabel = makeResultLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension LWAResultView {
    func setup(result: LWAResultElement) {
        let titleAttr = TextAttributes()
            .font(Fonts.Poppins.bold(size: 34.scale))
            .lineHeight(41.scale)
            .textColor(UIColor(integralRed: 83, green: 83, blue: 83))
            .textAlignment(.center)
        
        let subtitleAttr = TextAttributes()
            .font(Fonts.Poppins.regular(size: 20.scale))
            .lineHeight(30.scale)
            .textColor(UIColor(integralRed: 83, green: 83, blue: 83))
            .textAlignment(.center)
        
        let resultAttr = TextAttributes()
            .font(Fonts.Poppins.regular(size: 40.scale))
            .lineHeight(60.scale)
            .textColor(UIColor(integralRed: 83, green: 83, blue: 83))
            .textAlignment(.center)
        
        titleLabel.attributedText = (
            result.isSuccess
                ? "LWA.Result.Title.Success"
                : "LWA.Result.Title.Bad"
        )
        .localized
        .attributed(with: titleAttr)
        
        let unit = result.unit == .celsius ? "Celsius".localized : "Fahrenheit".localized
        resultLabel.attributedText = "\(result.min)-\(result.max) \(unit)".attributed(with: resultAttr)
        subtitleLabel.attributedText = "LWA.Result.Subtitle".localized.attributed(with: subtitleAttr)
        subtitleLabel.isHidden = result.isSuccess
        
        imageView.image = result.isSuccess
            ? UIImage(named: "LWA.Result.Success")
            : UIImage(named: "LWA.Result.Bad")
        
        
        makeConstraints(isSuccess: result.isSuccess)
    }
}

// MARK: Private
private extension LWAResultView {
    func initialize() {
        backgroundColor = UIColor.white
    }
}

// MARK: Make constraints
private extension LWAResultView {
    func makeConstraints(isSuccess: Bool) {
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: isSuccess ? 20.scale : 52.scale),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: isSuccess ? -20.scale : -52.scale),
            titleLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: isSuccess ? -25.scale : -10.scale)
        ])
        
        let imageHeightAnchor = ScreenSize.isIphoneXFamily ? isSuccess ? 234 : 219 : isSuccess ? 204 : 189
        imageView.heightAnchor.constraint(equalToConstant: imageHeightAnchor.scale).isActive = true
        
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 32.scale),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -32.scale)
        ])
        
        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 28.scale),
            resultLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 55.scale),
            resultLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -55.scale),
            resultLabel.bottomAnchor.constraint(equalTo: button.topAnchor, constant:  ScreenSize.isIphoneXFamily ? -106.scale : -56.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -50.scale : -30.scale),
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 97.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -97.scale),
            button.heightAnchor.constraint(equalToConstant: 56.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension LWAResultView {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubtitleLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(view)
        return view
    }
    
    func makeStackView() -> UIStackView {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 28.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeResultImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(view)
        return view
    }
    
    func makeResultLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(.white)
            .font(Fonts.Poppins.semiBold(size: 17.scale))
            .lineHeight(22.scale)
        
        let view = UIButton()
        view.layer.cornerRadius = 28.scale
        view.backgroundColor = UIColor(integralRed: 148, green: 165, blue: 225)
        view.setAttributedTitle("LWA.Result.Save".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
