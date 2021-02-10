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
        customButton
            .rx.tap
            .subscribe(onNext: { [weak self] in
                guard let this = self else {
                    return
                }
                
                let vc = CalendarPickerViewController(baseDate: Date()) { date in
                }
                
                this.journalVC?.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        
//        Observable
//            .merge(
//                todayButton.rx.tap.map { Filter.today },
//                days7Button.rx.tap.map { Filter.days7 },
//                days30Button.rx.tap.map { Filter.days30 },
//                customButton.rx.tap.map { Filter.custom }
//            )
//            .subscribe(onNext: { [weak self] filter in
//                guard let this = self else {
//                    return
//                }
//
//                let sColor = UIColor(integralRed: 148, green: 165, blue: 225)
//                let uColor = UIColor(integralRed: 161, green: 161, blue: 161)
//
//                if filter == this.filter.value {
//                    [
//                        this.todayButton,
//                        this.days7Button,
//                        this.days30Button,
//                        this.customButton
//                    ]
//                    .forEach {
//                        $0.setTitleColor(uColor, for: .normal)
//                    }
//
//                    this.filter.accept(.none)
//                } else {
//                    this.todayButton.setTitleColor(filter == .today ? sColor : uColor, for: .normal)
//                    this.days7Button.setTitleColor(filter == .days7 ? sColor : uColor, for: .normal)
//                    this.days30Button.setTitleColor(filter == .days30 ? sColor : uColor, for: .normal)
//                    this.customButton.setTitleColor(filter == .custom ? sColor : uColor, for: .normal)
//
//                    this.filter.accept(filter)
//                }
//            })
//            .disposed(by: disposeBag)
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
