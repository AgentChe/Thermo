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
        static let remindersCacheKey = "reminder_manager_core_reminders_cache_key"
    }
}

// MARK: API
extension ReminderManagerCore {
    func addRemindAt(time: Date, weekday: Weekday) -> Reminder? {
        let obj = Reminder(id: UUID().uuidString,
                           time: time,
                           weekday: weekday,
                           checked: true)
        
        var reminders = getReminders()
        reminders.append(obj)
        
        guard let data = try? JSONEncoder().encode(reminders) else {
            return nil
        }
        
        UserDefaults.standard.setValue(data, forKey: Constants.remindersCacheKey)
        
        ReminderManagerMediator.shared.notifyAboutAdded(reminder: obj)
        
        return obj
    }
    
    @discardableResult
    func set(id: String, checked: Bool) -> Bool {
        var reminders = getReminders()
        
        guard let cachedIndex = reminders.firstIndex(where: { $0.id == id }) else {
            return false
        }
        
        let cachedObj = reminders[cachedIndex]
        
        let obj = Reminder(id: cachedObj.id,
                           time: cachedObj.time,
                           weekday: cachedObj.weekday,
                           checked: checked)
        
        reminders[cachedIndex] = obj
        
        guard let data = try? JSONEncoder().encode(reminders) else {
            return false
        }
        
        UserDefaults.standard.setValue(data, forKey: Constants.remindersCacheKey)
        
        ReminderManagerMediator.shared.notifyAboutChanged(reminder: obj)
        
        return true
    }
    
    func getReminders() -> [Reminder] {
        guard
            let data = UserDefaults.standard.data(forKey: Constants.remindersCacheKey),
            let decodable = try? JSONDecoder().decode([Reminder].self, from: data)
        else {
            return []
        }
        
        return decodable
    }
    
    func remove(reminder: Reminder) {
        var reminders = getReminders()
        
        reminders.removeAll(where: { $0.id == reminder.id })
        
        guard let data = try? JSONEncoder().encode(reminders) else {
            return
        }
        
        UserDefaults.standard.setValue(data, forKey: Constants.remindersCacheKey)
        
        ReminderManagerMediator.shared.notifyAboutRemoved(reminder: reminder)
    }
}

// MARK: API(Rx)
extension ReminderManagerCore {
    func rxAddRemindAt(time: Date, weekday: Weekday) -> Single<Reminder?> {
        Single<Reminder?>
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                let result = this.addRemindAt(time: time, weekday: weekday)
                
                event(.success(result))
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
    }
    
    func rxSet(id: String, checked: Bool) -> Single<Bool> {
        Single<Bool>
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                let result = this.set(id: id, checked: checked)
                
                event(.success(result))
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
    }
    
    func rxObtainReminders() -> Single<[Reminder]> {
        Single<[Reminder]>
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                let result = this.getReminders()
                
                event(.success(result))
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
    }
    
    func rxRemove(reminder: Reminder) -> Single<Void> {
        Single<Void>
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                this.remove(reminder: reminder)
                
                event(.success(Void()))
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
    }
}
