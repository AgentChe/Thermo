//
//  FeelingManager.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 05.02.2021.
//

import RxSwift

protocol FeelingManager {
    // MARK: API
    func set(feeling: Feeling)
    func getSelected() -> Feeling
    
    // MARK: API(Rx)
    func rxSet(feeling: Feeling) -> Single<Void>
    func rxGetSelected() -> Single<Feeling>
}
