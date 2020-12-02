//
//  TCTreatmentViewController.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 02.12.2020.
//

import UIKit

final class TCTreatmentViewController: UIViewController {
    var mainView = TCTreatmentView()
    
    private let html: String
    
    private init(html: String) {
        self.html = html
        
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
        
        mainView.html = html 
    }
}

// MARK: Make
extension TCTreatmentViewController {
    static func make(html: String) -> TCTreatmentViewController {
        TCTreatmentViewController(html: html)
    }
}
