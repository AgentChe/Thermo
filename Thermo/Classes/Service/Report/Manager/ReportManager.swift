//
//  ReportManager.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 23.11.2020.
//

import RxSwift

protocol ReportManager: class {
    // MARK: API(Rx)
    func rxCreateReport(email: String, member: Member, records: [Record]) -> Single<Bool>
}
