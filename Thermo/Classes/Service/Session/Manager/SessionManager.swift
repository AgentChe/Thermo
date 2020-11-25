//
//  SessionManager.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 22.11.2020.
//

import RxCocoa

protocol SessionManager: class {
    // MARK: API
    func store(session: Session)
    func getSession() -> Session?
}
