//
//  TreatmentsViewModel.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 02.12.2020.
//

import RxSwift
import RxCocoa

final class TreatmentsViewModel {
    typealias Attributes = (String, Int, [Int], [Int])
    
    let loading = RxActivityIndicator()
    
    private let treatmentsManager = TreatmentsManagerCore()
    private let memberManager = MembersManagerCore()
    private let recordManager = RecordManagerCore()
}

// MARK: API
extension TreatmentsViewModel {
    func conditions() -> Driver<[TreatmentCondition]> {
        Single
            .zip(delay(), obtain()) { $1 }
            .trackActivity(loading)
            .asDriver(onErrorJustReturn: [])
    }
}

// MARK: Private
private extension TreatmentsViewModel {
    // Задержка для отображения анимации
    func delay() -> Single<Void> {
        Single<Void>
            .create { event in
                DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 3) {
                    DispatchQueue.main.async {
                        event(.success(Void()))
                    }
                }
                
                return Disposables.create()
            }
    }
    
    func obtain() -> Single<[TreatmentCondition]> {
        attributes()
            .flatMap { [weak self] attributes -> Single<[TreatmentCondition]> in
                guard let this = self else {
                    return .never()
                }
                
                let (gender, age, symptomsIds, medicinesIds) = attributes
                
                return this.treatmentsManager
                    .rxObtainConditions(gender: gender, age: age, symptomsIds: symptomsIds, medicinesIds: medicinesIds)
                    .catchAndReturn([])
            }
    }
    
    func attributes() -> Single<Attributes> {
        memberManager
            .rxCurrentMember()
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { [weak self] member -> Single<Attributes> in
                guard let this = self, let currentMember = member else {
                    return .never()
                }
                
                var _human: Human?
                switch currentMember.unit {
                case .me(let h), .child(let h), .parent(let h), .other(let h):
                    _human = h
                case .animal, .object:
                    _human = nil
                }
                
                guard let human = _human else {
                    return .never()
                }
                
                let gender = String(describing: human.gender)
                let age = Calendar.current.dateComponents([.year], from: human.dateBirthday, to: Date()).year ?? 0
                
                return this.recordManager
                    .rxGet(for: currentMember.id)
                    .map { records -> Attributes in
                        let keyDate = Date(timeIntervalSinceNow: -7 * 60 * 60 * 24)
                        let lastRecords = records
                            .compactMap { $0 as? HumanRecord }
                            .filter{ $0.date > keyDate }
                        
                        let symptomsIds = lastRecords.reduce([Int]()) { ids, record in
                            let newIds = record.symptoms.map { $0.id }
                            return ids + newIds
                        }
                        
                        let medicinesIds = lastRecords.reduce([Int]()) { ids, record in
                            let newIds = record.medicines.map { $0.id }
                            return ids + newIds
                        }
                        
                        return (gender, age, symptomsIds, medicinesIds)
                    }
            }
            .observe(on: MainScheduler.asyncInstance)
    }
}
