//
//  TreatmentsManager.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 02.12.2020.
//

import RxSwift

protocol TreatmentsManager {
    // API(Rx)
    func rxObtainConditions(gender: String, age: Int, symptomsIds: [Int], medicinesIds: [Int]) -> Single<[TreatmentCondition]>
}
