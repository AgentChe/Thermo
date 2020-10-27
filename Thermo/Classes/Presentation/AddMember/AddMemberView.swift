//
//  AddMemberView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.10.2020.
//

import UIKit

final class AddMemberView: GradientView {
    enum Step: Int {
        case memberUnitView = 0
        case temperatureUnitView = 1
    }
    
    lazy var scrollView = makeScrollView()
    lazy var button = makeButton()
    lazy var memberUnitView = AMMemberUnitView()
    lazy var temperatureUnitView = AMTemperatureUnitView()
    
    var step = Step.memberUnitView {
        didSet {
            scroll()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension AddMemberView {
    func configure() {
        gradientLayer.colors = [
            UIColor(integralRed: 221, green: 217, blue: 221).cgColor,
            UIColor(integralRed: 254, green: 234, blue: 235).cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        contentViews()
            .enumerated()
            .forEach { index, view in
                scrollView.addSubview(view)
                
                view.frame.origin = CGPoint(x: UIScreen.main.bounds.width * CGFloat(index), y: 0)
                view.frame.size = CGSize(width: UIScreen.main.bounds.width,
                                         height: UIScreen.main.bounds.height)
            }
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(contentViews().count),
                                        height: UIScreen.main.bounds.height)
    }
    
    func scroll() {
        let index = step.rawValue
        
        guard contentViews().indices.contains(index) else {
            return
        }
        
        let frame = contentViews()[index].frame
        
        scrollView.scrollRectToVisible(frame, animated: true)
    }
    
    func contentViews() -> [UIView] {
        [
            memberUnitView,
            temperatureUnitView
        ]
    }
}

// MARK: Make constraints
private extension AddMemberView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 34.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -34.scale),
            button.heightAnchor.constraint(equalToConstant: 56.scale),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -80.scale)
        ])
    }
}

// MARK: Lazy initalization
private extension AddMemberView {
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.backgroundColor = UIColor.clear
        view.isScrollEnabled = false
        view.isPagingEnabled = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.Poppins.semiBold(size: 17.scale))
            .lineHeight(22.scale)
        
        let view = UIButton()
        view.setAttributedTitle("Next".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 28.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
