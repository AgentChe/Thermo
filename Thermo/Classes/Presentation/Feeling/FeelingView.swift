//
//  FeelingView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 04.02.2021.
//

import UIKit

final class FeelingView: UIView {
    lazy var headerView = makeHeaderView()
    lazy var selectionView = makeSelectionView()
    lazy var measureView = makeMeasureView()
    
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
private extension FeelingView {
    func initialize() {
        backgroundColor = UIColor(integralRed: 246, green: 246, blue: 246)
    }
}

// MARK: Make constraints
private extension FeelingView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 291.scale : 160.scale)
        ])
        
        NSLayoutConstraint.activate([
            selectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            selectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            selectionView.heightAnchor.constraint(equalToConstant: 252.scale),
            selectionView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 305.scale : 250.scale.scale)
        ])
        
        NSLayoutConstraint.activate([
            measureView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            measureView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            measureView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 107.scale : 80.scale),
            measureView.topAnchor.constraint(equalTo: selectionView.bottomAnchor, constant: 20.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension FeelingView {
    func makeHeaderView() -> FeelingHeaderView {
        let view = FeelingHeaderView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSelectionView() -> FeelingSelectionView {
        let view = FeelingSelectionView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 40.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeMeasureView() -> FeelingMeasureView {
        let view = FeelingMeasureView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 40.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
