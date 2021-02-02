//
//  JournalTableTagsCell.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 24.11.2020.
//

import UIKit

final class JournalTableTagsCell: UITableViewCell {
    lazy var leftIconLabel = makeLeftIconLabel()
    lazy var tagsView = makeTagsView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension JournalTableTagsCell {
//    func setup(tags: JTTags) {
//        leftIconLabel.text = image(tags: tags)
//
//        tagsView.removeAllTags()
//
//        let views = tags
//            .tags
//            .map { tag -> TagView in
//                let view = TagView(model: TagViewModel(id: tag.id, name: tag.name))
//                view.textColor = UIColor(integralRed: 105, green: 121, blue: 248)
//                view.tagBackgroundColor = UIColor(integralRed: 229, green: 231, blue: 250)
//                view.cornerRadius = 4.scale
//                view.paddingX = 8.scale
//                view.paddingY = 6.scale
//                view.textFont = Fonts.Poppins.regular(size: 11.scale)
//                return view
//            }
//        tagsView.addTagViews(views)
//        tagsView.layoutIfNeeded()
//    }
}

// MARK: Private
private extension JournalTableTagsCell {
    func configure() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = .clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension JournalTableTagsCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            leftIconLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24.scale),
            leftIconLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tagsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 51.scale),
            tagsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24.scale),
            tagsView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.scale),
            tagsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension JournalTableTagsCell {
    func makeLeftIconLabel() -> UILabel {
        let view = UILabel()
        view.font = Fonts.Poppins.regular(size: 15.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTagsView() -> TagListView {
        let view = TagListView()
        view.backgroundColor = UIColor.clear
        view.marginX = 8.scale
        view.marginY = 6.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
