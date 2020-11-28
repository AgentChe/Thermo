//
//  LSSearchView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.11.2020.
//

import UIKit

final class LSSearchView: UIView {
    lazy var leftIconLabel = makeLeftIconLabel()
    lazy var rightImageView = makeRightIconView()
    lazy var textField = makeTextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension LSSearchView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            leftIconLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            leftIconLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 43.scale),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -43.scale),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            rightImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            rightImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightImageView.widthAnchor.constraint(equalToConstant: 16.scale),
            rightImageView.heightAnchor.constraint(equalToConstant: 16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension LSSearchView {
    func makeLeftIconLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextField() -> UITextField {
        let view = UITextField()
        view.placeholder = "ComboBox.TagsPlaceholder".localized
        view.textColor = UIColor.black
        view.font = Fonts.Poppins.regular(size: 15.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeRightIconView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "TemperatureLogger.Feeiling.Search")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
