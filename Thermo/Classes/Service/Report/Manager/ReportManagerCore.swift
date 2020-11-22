//
//  ReportManagerCore.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 23.11.2020.
//

import RxSwift

final class ReportManagerCore: ReportManager {}

// MARK: APi(Rx)
extension ReportManagerCore {
    func rxCreateReport(email: String, member: Member, temperatures: [Temperature]) -> Single<Bool> {
        SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: CreateReportRequest(email: email, member: member, temperatures: temperatures))
            .map { !ErrorChecker.hasError(in: $0) }
    }
}
