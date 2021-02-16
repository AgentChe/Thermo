//
//  SymptomsViewController.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 06.02.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class FSelectionViewController: UIViewController {
    enum Style {
        case medicines, symptoms
    }
    
    lazy var mainView = FSelectionView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel: FSelectionViewModel = {
        switch style {
        case .medicines:
            return FSelectionMedicinesViewModel()
        case .symptoms:
            return FSelectionSymptomsViewModel()
        }
    }()
    
    private let style: Style
    
    init(style: Style) {
        self.style = style
        
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
        
        mainView
            .closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        let elements = viewModel.elements
        
        Driver
            .combineLatest(
                elements,
                mainView
                    .searchView.didChange
                    .asDriver(onErrorJustReturn: "")
                    .startWith("")
            )
            .drive(onNext: { [weak self] stub in
                let (elements, text) = stub
                
                if text.isEmpty {
                    self?.mainView.tableView.setup(elements: elements)
                } else {
                    let filtered = elements
                        .filter { element -> Bool in
                            element.name.lowercased().range(of: text.lowercased()) != nil
                        }
                    
                    self?.mainView.tableView.setup(elements: filtered)
                }
            })
            .disposed(by: disposeBag)
        
        mainView
            .button.rx.tap
            .asObservable()
            .withLatestFrom(elements)
            .subscribe(onNext: { [weak self] elements in
                self?.viewModel.save.accept(elements.filter { $0.isSelected })
            })
            .disposed(by: disposeBag)
        
        viewModel
            .saved
            .drive(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        setup()
    }
}

// MARK: Make
extension FSelectionViewController {
    static func make(style: Style) -> FSelectionViewController {
        let vc = FSelectionViewController(style: style)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: Private
private extension FSelectionViewController {
    func setup() {
        let titleAttrs = TextAttributes()
            .textColor(UIColor(integralRed: 50, green: 50, blue: 52))
            .font(Fonts.Poppins.bold(size: 30.scale))
            .lineHeight(34.scale)
        
        let placeholderAttrs = TextAttributes()
            .textColor(UIColor(integralRed: 192, green: 192, blue: 192))
            .font(Fonts.Poppins.regular(size: 15.scale))
        
        switch style {
        case .medicines:
            mainView.titleLabel.attributedText = "FSelection.Medicines.Title".localized.attributed(with: titleAttrs)
            mainView.searchView.textField.attributedPlaceholder = "FSelection.Medicines.Placeholder".localized.attributed(with: placeholderAttrs)
        case .symptoms:
            mainView.titleLabel.attributedText = "FSelection.Symptoms.Title".localized.attributed(with: titleAttrs)
            mainView.searchView.textField.attributedPlaceholder = "FSelection.Symptoms.Placeholder".localized.attributed(with: placeholderAttrs)
        }
    }
}
