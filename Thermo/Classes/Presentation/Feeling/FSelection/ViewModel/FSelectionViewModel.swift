//
//  FSelectionViewModel.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 07.02.2021.
//

import RxSwift
import RxCocoa

enum FSelectionStep {
    case saved, paygate
}

protocol FSelectionViewModel {
    var save: PublishRelay<[FSelectionTableElement]> { get }
    
    var elements: Driver<[FSelectionTableElement]> { get }
    var step: Driver<FSelectionStep> { get }
}
