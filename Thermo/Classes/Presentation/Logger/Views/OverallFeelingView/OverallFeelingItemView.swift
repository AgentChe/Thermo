//
//  OverallFeelingItemView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 21.11.2020.
//

import UIKit

final class OverallFeelingItemView: UIView {
    lazy var emojiBackgroundView = makeEmojiBackgroundView()
    lazy var emojiLabel = makeEmojiLabel()
    lazy var checkedImageView = makeCheckedImageView()
    lazy var nameLabel = makeNameLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isChecked: Bool = false {
        didSet {
            checkedImageView.isHidden = !isChecked
        }
    }
}

// MARK: API
extension OverallFeelingItemView {
    func setup(emoji: String, name: String, checked: Bool = false) {
        emojiLabel.attributedText = emoji
            .attributed(with: TextAttributes()
                            .font(Fonts.Poppins.bold(size: 38.scale))
                            .lineHeight(57.scale)
                            .textAlignment(.center))
        
        nameLabel.attributedText = name
            .attributed(with: TextAttributes()
                .font(Fonts.Poppins.semiBold(size: 12.scale))
                .lineHeight(18.scale)
                .letterSpacing(0.5.scale)
                .textColor(UIColor.white)
                .textAlignment(.center))
        
        isChecked = checked
    }
}

// MARK: Make constraints
private extension OverallFeelingItemView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            emojiBackgroundView.widthAnchor.constraint(equalToConstant: 70.scale),
            emojiBackgroundView.heightAnchor.constraint(equalToConstant: 70.scale),
            emojiBackgroundView.topAnchor.constraint(equalTo: topAnchor),
            emojiBackgroundView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: emojiBackgroundView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiBackgroundView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            checkedImageView.widthAnchor.constraint(equalToConstant: 22.scale),
            checkedImageView.heightAnchor.constraint(equalToConstant: 22.scale),
            checkedImageView.bottomAnchor.constraint(equalTo: emojiBackgroundView.bottomAnchor),
            checkedImageView.trailingAnchor.constraint(equalTo: emojiBackgroundView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: emojiBackgroundView.bottomAnchor, constant: 4.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OverallFeelingItemView {
    func makeEmojiBackgroundView() -> CircleView {
        let view = CircleView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeEmojiLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        emojiBackgroundView.addSubview(view)
        return view
    }
    
    func makeCheckedImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "TemperatureLogger.Feeiling.Checked")
        view.translatesAutoresizingMaskIntoConstraints = false
        emojiBackgroundView.addSubview(view)
        return view
    }
    
    func makeNameLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        emojiBackgroundView.addSubview(view)
        return view
    }
}
