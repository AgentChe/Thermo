//
//  TreatmentsManagerCore.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 02.12.2020.
//

import RxSwift

final class TreatmentsManagerCore: TreatmentsManager {}

// MARK: API(Rx)
extension TreatmentsManagerCore {
    func rxObtainConditions(gender: String, age: Int, symptomsIds: [Int], medicinesIds: [Int]) -> Single<[TreatmentCondition]> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetTreatmentsConditionsRequest(userToken: userToken,
                                                     gender: gender,
                                                     age: age,
                                                     symptomsIds: symptomsIds,
                                                     medicinesIds: medicinesIds)
        
        return SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: request)
            .map { GetTreatmentsResponseMapper.map(from: $0) }
    }
}
