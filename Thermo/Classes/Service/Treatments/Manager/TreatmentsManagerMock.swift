//
//  TreatmentsManagerMock.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 02.12.2020.
//

import RxSwift

final class TreatmentsManagerMock: TreatmentsManager {}

// MARK: API(Rx)
extension TreatmentsManagerMock {
    func rxObtainConditions(gender: String, age: Int, symptomsIds: [Int], medicinesIds: [Int]) -> Single<[TreatmentCondition]> {
        Single<[TreatmentCondition]>
            .create { event in
                guard
                    let url = Bundle.main.url(forResource: "GetTreatmentConditionsResponseJSON", withExtension: "json"),
                    let data = try? Data(contentsOf: url),
                    let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                else {
                    return Disposables.create()
                }
                
                let conditions = GetTreatmentsResponseMapper.map(from: json)
                
                event(.success(conditions))
                
                return Disposables.create()
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.asyncInstance)
    }
}
