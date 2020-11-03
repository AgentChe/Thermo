//
//  JournalView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import UIKit

final class JournalView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var imageView = makeImageView()
    lazy var tableView = makeTableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension JournalView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 52.scale),
            imageView.heightAnchor.constraint(equalToConstant: 52.scale),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 90)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            titleLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 60.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension JournalView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 50, green: 50, blue: 52))
            .font(Fonts.Poppins.bold(size: 28.scale))
            .lineHeight(34.scale)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Journal.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    // TODO: Удалить бэкграунд
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.backgroundColor = UIColor.black
        view.layer.cornerRadius = 26.scale
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> JournalTableView {
        let view = JournalTableView()
        view.separatorStyle = .none
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
