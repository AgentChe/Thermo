//
//  LWAOnboardingStepView.swift
//  Thermo
//
//  Created by Vitaliy Zagorodnov on 06.02.2021.
//

import UIKit

class LWAOnboardingStepView: UIView {
    private lazy var stepNumberLabel = makeStepNumberLabel()
    private lazy var stepMessgeLabel = makeStepMessageLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: Public
extension LWAOnboardingStepView {
    func setup(step: Int, message: String) {
        let stepAttr = TextAttributes()
            .font(Fonts.Poppins.regular(size: 17.scale))
            .lineHeight(25.scale)
            .textColor(.white)
            .textAlignment(.center)
        
        let messageAttr = TextAttributes()
            .font(Fonts.Poppins.regular(size: 17.scale))
            .lineHeight(25.scale)
            .textColor(.black)
            .textAlignment(.left)
        
        stepNumberLabel.attributedText = "\(step)".attributed(with: stepAttr)
        stepMessgeLabel.attributedText = message.attributed(with: messageAttr)
    }
}

// MARK: Private
private extension LWAOnboardingStepView {
    func initialize() {
        backgroundColor = .clear
    }
}

// MARK: Make constraints
private extension LWAOnboardingStepView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            stepNumberLabel.leftAnchor.constraint(equalTo: leftAnchor),
            stepNumberLabel.topAnchor.constraint(equalTo: topAnchor),
            stepNumberLabel.heightAnchor.constraint(equalToConstant: 28.scale),
            stepNumberLabel.widthAnchor.constraint(equalTo: stepNumberLabel.heightAnchor),
            stepNumberLabel.rightAnchor.constraint(equalTo: stepMessgeLabel.leftAnchor, constant: -10.scale)
        ])
        
        NSLayoutConstraint.activate([
            stepMessgeLabel.topAnchor.constraint(equalTo: stepNumberLabel.topAnchor),
            stepMessgeLabel.rightAnchor.constraint(equalTo: rightAnchor),
            stepMessgeLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension LWAOnboardingStepView {
    func makeStepNumberLabel() -> UILabel{
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 14.scale
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(integralRed: 148, green: 165, blue: 225)
        addSubview(view)
        return view
    }
    
    func makeStepMessageLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        addSubview(view)
        return view
    }
}
