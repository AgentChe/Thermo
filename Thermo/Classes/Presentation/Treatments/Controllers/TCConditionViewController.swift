//
//  TCConditionViewController.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 02.12.2020.
//

import UIKit
import RxSwift

final class TCConditionViewController: UIViewController {
    lazy var mainView = TCDetailView(hideNextButton: isLast)
    
    private let disposeBag = DisposeBag()
    
    private let condition: TreatmentCondition
    private let isLast: Bool
    private let onNext: (() -> Void)
    
    private init(condition: TreatmentCondition, isLast: Bool, onNext: @escaping (() -> Void)) {
        self.condition = condition
        self.isLast = isLast
        self.onNext = onNext
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTreatmentNavButton()
        
        mainView.titleLabel.attributedText = condition.name
            .attributed(with: TextAttributes()
                            .textColor(UIColor.white)
                            .font(Fonts.Poppins.bold(size: 34.scale))
                            .lineHeight(41.scale)
                            .textAlignment(.center))
        
        mainView.scoreView.score = CGFloat(condition.score)
        
        mainView.scoreLabel.attributedText = String(format: "%i %", Int(condition.score))
            .attributed(with: TextAttributes()
                            .textColor(UIColor.white)
                            .font(Fonts.Poppins.bold(size: 34.scale))
                            .lineHeight(41.scale)
                            .textAlignment(.center))
        
        mainView.textView.attributedText = HTMLString(string: condition.detail).htmlAttributedString
        
        mainView.button.rx
            .tap
            .subscribe(onNext: onNext)
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension TCConditionViewController {
    static func make(condition: TreatmentCondition, isLast: Bool, onNext: @escaping (() -> Void)) -> TCConditionViewController {
        TCConditionViewController(condition: condition, isLast: isLast, onNext: onNext)
    }
}

// MARK: Private(NavItem)
private extension TCConditionViewController {
    func addTreatmentNavButton() {
        navigationItem.rightBarButtonItem = makeNavButton()
    }
    
    func makeNavButton() -> UIBarButtonItem {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = "Treatments.Details.TreatmentButton".localized
            .attributed(with: TextAttributes()
                            .textColor(UIColor.white)
                            .lineHeight(22.scale)
                            .font(Fonts.Poppins.regular(size: 16.scale))
                            .letterSpacing(-0.41.scale))
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Treatments.Arrow2")
        imageView.tintColor = UIColor.white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 12.scale),
            imageView.heightAnchor.constraint(equalToConstant: 20.scale),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .subscribe(onNext: { [weak self] event in
                guard let this = self else {
                    return
                }
                
                let vc = TCTreatmentViewController.make(html: this.condition.treatment)
                this.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        return UIBarButtonItem(customView: view)
    }
}
