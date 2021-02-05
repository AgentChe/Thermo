//
//  SLViewController.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 06.02.2021.
//

import UIKit
import RxSwift

final class SLViewController: UIViewController {
    enum Select {
        case withApp, manually
    }
    
    lazy var mainView = SLView()
    
    private lazy var disposeBag = DisposeBag()
    
    private let selected: ((Select) -> Void)
    
    private init(selected: @escaping ((Select) -> Void)) {
        self.selected = selected
        
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSelectAction()
        addHideAction()
        
        rx.methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                self?.animate()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension SLViewController {
    static func make(selected: @escaping ((Select) -> Void)) -> SLViewController {
        let vc = SLViewController(selected: selected)
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
}

// MARK: Private
private extension SLViewController {
    func addSelectAction() {
        let withAppGesture = UITapGestureRecognizer()
        mainView.withAppCell.isUserInteractionEnabled = true
        mainView.withAppCell.addGestureRecognizer(withAppGesture)
        
        let manuallyGesture = UITapGestureRecognizer()
        mainView.manuallyCell.isUserInteractionEnabled = true
        mainView.manuallyCell.addGestureRecognizer(manuallyGesture)
        
        Observable
            .merge(
                withAppGesture.rx.event.map { event in Select.withApp },
                manuallyGesture.rx.event.map { event in Select.manually }
            )
            .subscribe(onNext: { [weak self] select in
                self?.selected(select)
            })
            .disposed(by: disposeBag)
    }
    
    func addHideAction() {
        let gesture = UITapGestureRecognizer()
        mainView.tappedView.addGestureRecognizer(gesture)
        
        gesture.rx.event
            .subscribe(onNext: { [weak self] event in
                self?.dismiss(animated: false)
            })
            .disposed(by: disposeBag)
    }
    
    func animate() {
        mainView.bottom.constant = 0
        
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.mainView.layoutIfNeeded()
        })
    }
}
