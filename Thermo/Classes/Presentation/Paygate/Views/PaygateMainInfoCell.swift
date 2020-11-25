//
//  PaygateMainInfoCell.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 25.11.2020.
//

import UIKit

final class PaygateMainInfoCell: UIView {
    lazy var emojiBackgroundView = makeEmojiBackgroundView()
    lazy var emojiView = makeEmojiView()
    lazy var label = makeLabel()
    
    var title: String = "" {
        didSet {
            label.attributedText = title
                .attributed(with: TextAttributes()
                                .textColor(UIColor.white)
                                .font(Fonts.Poppins.regular(size: 17.scale))
                                .lineHeight(28.scale)
                                .letterSpacing(-0.5.scale))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension PaygateMainInfoCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            emojiBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emojiBackgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
            emojiBackgroundView.widthAnchor.constraint(equalToConstant: 48.scale),
            emojiBackgroundView.heightAnchor.constraint(equalToConstant: 48.scale)
        ])
        
        NSLayoutConstraint.activate([
            emojiView.centerXAnchor.constraint(equalTo: emojiBackgroundView.centerXAnchor),
            emojiView.centerYAnchor.constraint(equalTo: emojiBackgroundView.centerYAnchor),
            emojiView.widthAnchor.constraint(equalToConstant: 14.scale),
            emojiView.heightAnchor.constraint(equalToConstant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 58.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.scale),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension PaygateMainInfoCell {
    func makeEmojiBackgroundView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Paygate.InfoCellBackground")
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeEmojiView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        emojiBackgroundView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
