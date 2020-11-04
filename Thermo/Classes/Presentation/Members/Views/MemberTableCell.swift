//
//  MemberTableCell.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 29.10.2020.
//

import UIKit

final class MemberTableCell: UITableViewCell {
    lazy var avatarImageView = makeImageView()
    lazy var label = makeLabel()
    
    private let imageManager = ImageManagerCore()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension MemberTableCell {
    func setup(member: Member) {
        label.attributedText = member.name
            .attributed(with: TextAttributes()
                            .textColor(UIColor.black)
                            .font(Fonts.Poppins.semiBold(size: 17.scale))
                            .lineHeight(27.scale)
                            .letterSpacing(-0.4.scale))
        
        imageManager
            .retrieve(key: member.imageKey) { [weak self] image in
                self?.avatarImageView.image = image
            }
    }
}

// MARK: Private
private extension MemberTableCell {
    func configure() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension MemberTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 36.scale),
            avatarImageView.heightAnchor.constraint(equalToConstant: 36.scale),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 36.scale),
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 89.scale),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24.scale),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension MemberTableCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 18.scale
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
