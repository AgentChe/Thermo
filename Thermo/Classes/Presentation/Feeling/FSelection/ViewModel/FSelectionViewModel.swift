//
//  FSelectionViewModel.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 07.02.2021.
//

import RxSwift
import RxCocoa

protocol FSelectionViewModel {
    var save: PublishRelay<[FSelectionTableElement]> { get }
    
    var elements: Driver<[FSelectionTableElement]> { get }
    var saved: Driver<Void> { get }
}
