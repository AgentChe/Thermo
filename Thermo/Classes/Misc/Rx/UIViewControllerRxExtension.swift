//
//  UIViewControllerRxExtension.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 26.10.2020.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    var keyboardHeight: Observable<CGFloat> {
        return Observable
            .from([
                NotificationCenter.default.rx
                    .notification(UIApplication.keyboardWillShowNotification)
                    .map { notification -> CGFloat in
                        return (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
                    },
                
                NotificationCenter.default.rx
                    .notification(UIApplication.keyboardWillHideNotification)
                    .map { notification -> CGFloat in
                        return 0
                    }
            ])
            .merge()
            .distinctUntilChanged()
    }
    
    var hideKeyboardObserver: Binder<Void> {
        return Binder(base) { base, _ in
            base.view.endEditing(true)
        }
    }
    
    var hiddenNavBarObserver: Binder<Bool> {
        return Binder(base) { base, hidden in
            base.navigationController?.setNavigationBarHidden(hidden, animated: true)
        }
    }
    
    var hiddenNavBarAndToolBarObserver: Binder<Bool> {
        return Binder(base) { base, hidden in
            base.navigationController?.setNavigationBarHidden(hidden, animated: true)
            base.navigationController?.setToolbarHidden(hidden, animated: true)
        }
    }
}
