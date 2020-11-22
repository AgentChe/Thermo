//
//  ReportViewModel.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 22.11.2020.
//

import RxSwift
import RxCocoa

final class ReportViewModel {
    enum Step {
        case created
        case failure
    }
    
    let create = PublishRelay<String>()
    
    lazy var step = createStep()
    
    private let reportManager = ReportManagerCore()
    private let membersManager = MembersManagerCore()
    private let temperaturesManager = TemperatureManagerCore()
}

// MARK: Private
private extension ReportViewModel {
    func createStep() -> Driver<Step> {
        create
            .flatMapLatest { [weak self] email -> Single<Step> in
                guard let this = self else {
                    return .never()
                }
                
                guard let currentMember = this.membersManager.currentMember() else {
                    return .deferred {
                        .just(.failure)
                    }
                }
                
                let temperatures = this.temperaturesManager.get(for: currentMember.id)
                
                return this.reportManager
                    .rxCreateReport(email: email, member: currentMember, temperatures: temperatures)
                    .map { $0 ? Step.created : Step.failure }
            }
            .asDriver(onErrorJustReturn: .failure)
    }
}
