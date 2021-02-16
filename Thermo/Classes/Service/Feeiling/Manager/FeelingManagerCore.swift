//
//  FeelingManagerCore.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 05.02.2021.
//

import RxSwift

final class FeelingManagerCore: FeelingManager {
    struct Constants {
        static let selectedCacheKey = "feeling_manager_core_selected_cache_key"
        static let selectedDateKey = "feeling_manager_core_selected_date_key"
    }
}

// MARK: API
extension FeelingManagerCore {
    func set(feeling: Feeling) {
        guard let data = try? JSONEncoder().encode(feeling) else {
            return
        }
        
        UserDefaults.standard.setValue(data, forKey: Constants.selectedCacheKey)
        UserDefaults.standard.setValue(Date(), forKey: Constants.selectedDateKey)
    }
    
    func getSelected() -> Feeling {
        guard
            let data = UserDefaults.standard.data(forKey: Constants.selectedCacheKey),
            let date = UserDefaults.standard.object(forKey: Constants.selectedDateKey) as? Date
        else {
            return .good
        }
        
        guard Calendar.current.isDateInToday(date) else {
            return .good
        }
        
        let feeling = try? JSONDecoder().decode(Feeling.self, from: data)
        
        return feeling ?? .good
    }
}

// MARK: API(Rx)
extension FeelingManagerCore {
    func rxSet(feeling: Feeling) -> Single<Void> {
        Single<Void>
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                this.set(feeling: feeling)
                
                event(.success(Void()))
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
    }
    
    func rxGetSelected() -> Single<Feeling> {
        Single<Feeling>
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                let feeling = this.getSelected()
                
                event(.success(feeling))
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
    }
}
