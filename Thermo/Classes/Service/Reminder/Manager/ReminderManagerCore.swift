//
//  ReminderManagerCore.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 02.11.2020.
//

import RxSwift
import RxCocoa

final class ReminderManagerCore: ReminderManager {
    struct Constants {
        static let remindersTimeCacheKey = "reminder_manager_core_reminders_time_cache_key"
        static let remindersWeekdayCacheKey = "reminder_manager_core_reminders_weekday_cache_key"
    }
    
    private var delegates = [Weak<ReminderManagerDelegate>]()
    
    private let didAddTrigger = PublishRelay<ReminderTime>()
    private let didChangeTimeTrigger = PublishRelay<ReminderTime>()
    private let didChangeWeekdayTrigger = PublishRelay<ReminderWeekday>()
}

// MARK: API
extension ReminderManagerCore {
    func addRemindAt(time: Date, checked: Bool = false) -> ReminderTime? {
        let obj = ReminderTime(id: UUID().uuidString, time: time, checked: checked)
        
        var reminders = getRemindersTime()
        reminders.append(obj)
        
        guard let data = try? JSONEncoder().encode(reminders) else {
            return nil
        }
        
        UserDefaults.standard.setValue(data, forKey: Constants.remindersTimeCacheKey)
        
        delegates.forEach {
            $0.weak?.reminderManagerDidAdd(reminderTime: obj)
        }
        
        didAddTrigger.accept(obj)
        
        return obj
    }
    
    @discardableResult
    func set(timeId: String, checked: Bool) -> Bool {
        var reminders = getRemindersTime()
        
        guard let cachedIndex = reminders.firstIndex(where: { $0.id == timeId }) else {
            return false
        }
        
        let cachedObj = reminders[cachedIndex]
        
        let obj = ReminderTime(id: cachedObj.id, time: cachedObj.time, checked: checked)
        
        reminders[cachedIndex] = obj
        
        guard let data = try? JSONEncoder().encode(reminders) else {
            return false
        }
        
        UserDefaults.standard.setValue(data, forKey: Constants.remindersTimeCacheKey)
        
        delegates.forEach {
            $0.weak?.reminderManagerDidChange(time: obj)
        }
        
        didChangeTimeTrigger.accept(obj)
        
        return true
    }
    
    @discardableResult
    func set(weekday: Weekday, checked: Bool) -> Bool {
        var reminders = getRemindersWeekday()
        
        guard let cachedIndex = reminders.firstIndex(where: { $0.weekday == weekday }) else {
            return false
        }
        
        let obj = ReminderWeekday(weekday: weekday, checked: checked)
        
        reminders[cachedIndex] = obj
        
        guard let data = try? JSONEncoder().encode(reminders) else {
            return false
        }
        
        UserDefaults.standard.setValue(data, forKey: Constants.remindersWeekdayCacheKey)
        
        delegates.forEach {
            $0.weak?.reminderManagerDidChange(weekday: obj)
        }
        
        didChangeWeekdayTrigger.accept(obj)
        
        return true
    }
    
    func getRemindersTime() -> [ReminderTime] {
        getCached(key: Constants.remindersTimeCacheKey)
    }
    
    func getRemindersWeekday() -> [ReminderWeekday] {
        let cached: [ReminderWeekday] = getCached(key: Constants.remindersWeekdayCacheKey)
        
        if cached.isEmpty {
            return generateAndStoreWeekdays()
        } else {
            return cached
        }
    }
}

// MARK: API(Rx)
extension ReminderManagerCore {
    func rxAddRemindAt(time: Date, checked: Bool = false) -> Single<ReminderTime?> {
        Single<ReminderTime?>
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                let result = this.addRemindAt(time: time, checked: checked)
                
                event(.success(result))
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
    }
    
    func rxSet(timeId: String, checked: Bool) -> Single<Bool> {
        Single<Bool>
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                let result = this.set(timeId: timeId, checked: checked)
                
                event(.success(result))
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
    }
    
    func rxSet(weekday: Weekday, checked: Bool) -> Single<Bool> {
        Single<Bool>
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                let result = this.set(weekday: weekday, checked: checked)
                
                event(.success(result))
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
    }
    
    func rxObtainRemindersTime() -> Single<[ReminderTime]> {
        Single<[ReminderTime]>
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                let result = this.getRemindersTime()
                
                event(.success(result))
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
    }
    
    func rxObtainRemindersWeekday() -> Single<[ReminderWeekday]> {
        Single<[ReminderWeekday]>
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                let result = this.getRemindersWeekday()
                
                event(.success(result))
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
    }
}

// MARK: Triggers(Rx)
extension ReminderManagerCore {
    var rxDidAdd: Signal<ReminderTime> {
        didAddTrigger.asSignal()
    }
    
    var rxDidChangeTime: Signal<ReminderTime> {
        didChangeTimeTrigger.asSignal()
    }
    
    var rxDidChangeWeekday: Signal<ReminderWeekday> {
        didChangeWeekdayTrigger.asSignal()
    }
}

// MARK: Observer
extension ReminderManagerCore {
    func add(observer: ReminderManagerDelegate) {
        let weakly = observer as AnyObject
        delegates.append(Weak<ReminderManagerDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }
    
    func remove(observer: ReminderManagerDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === observer }) {
            delegates.remove(at: index)
        }
    }
}

// MARK: Private
private extension ReminderManagerCore {
    func getCached<T: Decodable>(key: String) -> [T] {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let decodable = try? JSONDecoder().decode([T].self, from: data)
        else {
            return []
        }
        
        return decodable
    }
    
    func generateAndStoreWeekdays() -> [ReminderWeekday] {
        let array = [
            ReminderWeekday(weekday: .monday, checked: false),
            ReminderWeekday(weekday: .tuesday, checked: false),
            ReminderWeekday(weekday: .wednesday, checked: false),
            ReminderWeekday(weekday: .thursday, checked: false),
            ReminderWeekday(weekday: .friday, checked: false),
            ReminderWeekday(weekday: .saturday, checked: false),
            ReminderWeekday(weekday: .sunday, checked: false),
        ]
        
        guard let data = try? JSONEncoder().encode(array) else {
            return []
        }
        
        UserDefaults.standard.setValue(data, forKey: Constants.remindersWeekdayCacheKey)
        
        return array
    }
}
