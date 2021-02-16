//
//  FSSearchView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 07.02.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class FSSearchView: UIView {
    lazy var imageView = makeImageView()
    lazy var textField = makeTextField()
    lazy var clearButton = makeClearButton()
    
    private lazy var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Rx
extension FSSearchView {
    var didChange: Signal<String> {
        let input = textField.rx.text
            .map { $0 ?? "" }
            .asSignal(onErrorJustReturn: "")
        
        let clear = clearButton.rx.tap
            .map { "" }
            .asSignal(onErrorJustReturn: "")
        
        return Signal
            .merge(input, clear)
    }
}

// MARK: Private
private extension FSSearchView {
    func initialize() {
        didChange
            .startWith("")
            .emit(onNext: { [weak self] text in
                self?.clearButton.isHidden = text.isEmpty
            })
            .disposed(by: disposeBag)
        
        clearButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.textField.text = ""
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make constraints
private extension FSSearchView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 18.scale),
            imageView.heightAnchor.constraint(equalToConstant: 18.scale),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48.scale),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -45.scale),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            clearButton.widthAnchor.constraint(equalToConstant: 13.scale),
            clearButton.heightAnchor.constraint(equalToConstant: 13.scale),
            clearButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            clearButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension FSSearchView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Symptoms.Search")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextField() -> UITextField {
        let view = UITextField()
        view.textColor = UIColor(integralRed: 63, green: 61, blue: 86)
        view.font = Fonts.Poppins.regular(size: 15.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeClearButton() -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: "Symptoms.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
