//
//  JournalFilterView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 09.02.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class JournalFilterView: UIView {
    enum Filter {
        case none
        case today
        case days7
        case days30
        case custom(Date)
    }
    
    weak var journalVC: JournalViewController?
    
    lazy var todayButton = makeButton(text: "Journal.Calendar.Today")
    lazy var days7Button = makeButton(text: "Journal.Calendar.7Days")
    lazy var days30Button = makeButton(text: "Journal.Calendar.30Days")
    lazy var customButton = makeButton(text: "Journal.Calendar.Custom")
    
    lazy var filter = BehaviorRelay<Filter>(value: .none)
    
    private lazy var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        addActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension JournalFilterView {
    func addActions() {
        todayButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.deselectAll()
                
                self?.todayButton.setTitleColor(UIColor(integralRed: 148, green: 165, blue: 225), for: .normal)
                
                self?.filter.accept(.today)
            })
            .disposed(by: disposeBag)
        
        days7Button.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.deselectAll()
                
                self?.days7Button.setTitleColor(UIColor(integralRed: 148, green: 165, blue: 225), for: .normal)
                
                self?.filter.accept(.days7)
            })
            .disposed(by: disposeBag)
        
        days30Button.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.deselectAll()
                
                self?.days30Button.setTitleColor(UIColor(integralRed: 148, green: 165, blue: 225), for: .normal)
                
                self?.filter.accept(.days30)
            })
            .disposed(by: disposeBag)
        
        customButton
            .rx.tap
            .subscribe(onNext: { [weak self] in
                guard let this = self else {
                    return
                }
                
                this.deselectAll()
                
                this.customButton.setTitleColor(UIColor(integralRed: 148, green: 165, blue: 225), for: .normal)
                
                let vc = CalendarPickerViewController(baseDate: Date()) { date in
                    this.filter.accept(.custom(date))
                }
                
                this.journalVC?.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func deselectAll() {
        let uColor = UIColor(integralRed: 161, green: 161, blue: 161)
        
        [
            todayButton,
            days7Button,
            days30Button,
            customButton
        ]
        .forEach {
            $0.setTitleColor(uColor, for: .normal)
        }
    }
}

// MARK: Make constraints
private extension JournalFilterView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            todayButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30.scale),
            todayButton.heightAnchor.constraint(equalToConstant: 27.scale),
            todayButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            days7Button.leadingAnchor.constraint(equalTo: todayButton.trailingAnchor, constant: 20.scale),
            days7Button.heightAnchor.constraint(equalToConstant: 27.scale),
            days7Button.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            days30Button.leadingAnchor.constraint(equalTo: days7Button.trailingAnchor, constant: 20.scale),
            days30Button.heightAnchor.constraint(equalToConstant: 27.scale),
            days30Button.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            customButton.leadingAnchor.constraint(equalTo: days30Button.trailingAnchor, constant: 20.scale),
            customButton.heightAnchor.constraint(equalToConstant: 27.scale),
            customButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension JournalFilterView {
    func makeButton(text: String) -> UIButton {
        let view = UIButton()
        view.backgroundColor = UIColor.clear
        view.setTitleColor(UIColor(integralRed: 161, green: 161, blue: 161), for: .normal)
        view.titleLabel?.font = Fonts.Poppins.semiBold(size: 17.scale)
        view.setTitle(text.localized, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
