//
//  SymptomsView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 06.02.2021.
//

import UIKit

final class FSelectionView: UIView {
    lazy var closeButton = makeCloseButton()
    lazy var titleLabel = makeTitleLabel()
    lazy var searchView = makeSearchView()
    lazy var tableView = makeTableView()
    lazy var button = makeButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension FSelectionView {
    func initialize() {
        backgroundColor = UIColor(integralRed: 246, green: 246, blue: 246)
    }
}

// MARK: Make constraints
private extension FSelectionView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scale),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 59.scale : 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 100.scale : 55.scale)
        ])
        
        NSLayoutConstraint.activate([
            searchView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28.scale),
            searchView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28.scale),
            searchView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30.scale),
            searchView.heightAnchor.constraint(equalToConstant: 48.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28.scale),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28.scale),
            tableView.topAnchor.constraint(equalTo: searchView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 180.scale),
            button.heightAnchor.constraint(equalToConstant: 56.scale),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -50.scale : -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension FSelectionView {
    func makeCloseButton() -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: "Symptoms.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSearchView() -> FSSearchView {
        let view = FSSearchView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 20.scale
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> FSelectionTableView {
        let view = FSelectionTableView()
        view.showsVerticalScrollIndicator = true
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 20.scale
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.separatorStyle = .none
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .font(Fonts.Poppins.semiBold(size: 17.scale))
            .textColor(UIColor.white)
        
        let view = UIButton()
        view.layer.cornerRadius = 28.scale
        view.backgroundColor = UIColor(integralRed: 148, green: 165, blue: 225)
        view.setAttributedTitle("FSelection.Button".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
