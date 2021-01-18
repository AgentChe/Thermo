//
//  LSelectCaseViewController.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 15.01.2021.
//

import UIKit
import RxSwift

final class LSelectCaseViewController: UIViewController {
    enum Cases {
        case withApp, appleHealth, manually
    }
    
    lazy var mainView = LSelectCaseView()
    
    private(set) var selectedCase: Cases = .withApp
    
    private lazy var disposeBag = DisposeBag()
    
    private let finish: ((LSelectCaseViewController) -> Void)
    
    private init(finish: @escaping ((LSelectCaseViewController) -> Void)) {
        self.finish = finish
        
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
        
        addSelectActions()
        update(selected: .withApp)
        
        mainView
            .button.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let this = self else {
                    return
                }
                
                this.finish(this)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension LSelectCaseViewController {
    static func make(finish: @escaping ((LSelectCaseViewController) -> Void)) -> LSelectCaseViewController {
        let vc = LSelectCaseViewController(finish: finish)
        vc.modalPresentationStyle = .overFullScreen
        return vc 
    }
}

// MARK: Private
private extension LSelectCaseViewController {
    func addSelectActions() {
        let withAppGesture = UITapGestureRecognizer()
        mainView.withAppCell.isUserInteractionEnabled = true
        mainView.withAppCell.addGestureRecognizer(withAppGesture)
        
        let appleHealthGesture = UITapGestureRecognizer()
        mainView.appleHealthCell.isUserInteractionEnabled = true
        mainView.appleHealthCell.addGestureRecognizer(appleHealthGesture)
        
        let manuallyGesture = UITapGestureRecognizer()
        mainView.manuallyCell.isUserInteractionEnabled = true
        mainView.manuallyCell.addGestureRecognizer(manuallyGesture)
        
        Observable
            .merge(withAppGesture.rx.event.map { event in Cases.withApp },
                   appleHealthGesture.rx.event.map { event in Cases.appleHealth },
                   manuallyGesture.rx.event.map { event in Cases.manually })
            .subscribe(onNext: update(selected:))
            .disposed(by: disposeBag)
    }
    
    func update(selected: Cases) {
        [
            mainView.withAppCell,
            mainView.appleHealthCell,
            mainView.manuallyCell
        ]
        .forEach {
            $0.checkedView.image = UIImage(named: "LoggerType.Unchecked")
        }
        
        self.selectedCase = selected
        
        switch selected {
        case .withApp:
            mainView.withAppCell.checkedView.image = UIImage(named: "LoggerType.Checked")
        case .appleHealth:
            mainView.appleHealthCell.checkedView.image = UIImage(named: "LoggerType.Checked")
        case .manually:
            mainView.manuallyCell.checkedView.image = UIImage(named: "LoggerType.Checked")
        }
    }
}
