//
//  ReminderNotificationsManager.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 03.11.2020.
//

import RxSwift

final class ReminderNotificationsManager {
    private let center = UNUserNotificationCenter.current()
    
    func rxPost(reminders: Reminders) -> Completable {
        Completable
            .create { [weak self] event in
                self?.post(reminders: reminders)
                
                event(.completed)
                
                return Disposables.create()
            }
    }
    
    func post(reminders: Reminders) {
        let triggers = getTriggers(from: reminders)
        let requests = getRequests(from: triggers)
        
        center.getPendingNotificationRequests { [weak self] pendingRequests in
            guard let this = self else {
                return
            }
            
            let requestsIdsForRemove = pendingRequests
                .filter { pendingRequest in !requests.contains(where: { $0.identifier == pendingRequest.identifier }) }
                .map { $0.identifier }
            
            this.center.removePendingNotificationRequests(withIdentifiers: requestsIdsForRemove)
            
            for request in requests {
                this.center.add(request, withCompletionHandler: nil)
            }
        }
    }
}

// MARK: Trigger
private struct Trigger {
    let id: String
    let dateComponents: DateComponents
}

// MARK: Private
private extension ReminderNotificationsManager {
    func getRequests(from triggers: [Trigger]) -> [UNNotificationRequest] {
        triggers
            .map { trigger -> UNNotificationRequest in
                let content = UNMutableNotificationContent()
                content.title = "Reminder.Notification.Title".localized
                content.body = "Reminder.Notification.Body".localized
                content.sound = UNNotificationSound.default
                
                let unTrigger = UNCalendarNotificationTrigger(dateMatching: trigger.dateComponents, repeats: true)
                
                return UNNotificationRequest(identifier: trigger.id, content: content, trigger: unTrigger)
            }
    }
    
    func getTriggers(from reminders: Reminders) -> [Trigger] {
        let times = reminders.times
        let weekdays = reminders.weekdays
        
        if weekdays.isEmpty {
            return times.map {
                var components = DateComponents()
                components.hour = Calendar.current.component(.hour, from: $0.time)
                components.minute = Calendar.current.component(.minute, from: $0.time)
                
                return Trigger(id: $0.id, dateComponents: components)
            }
        } else {
            var triggers = [Trigger]()
            
            times.forEach { time in
                weekdays.forEach { weekday in
                    var components = DateComponents()
                    components.hour = Calendar.current.component(.hour, from: time.time)
                    components.minute = Calendar.current.component(.minute, from: time.time)
                    components.weekday = self.weekday(weekday.weekday)
                    
                    let id = String(format: "%%_%@", time.id, String(describing: weekday.weekday))
                    
                    let trigger = Trigger(id: id, dateComponents: components)
                    
                    triggers.append(trigger)
                }
            }
            
            return triggers
        }
    }
    
    func weekday(_ weekday: Weekday) -> Int {
        switch weekday {
        case .monday:
            return 2
        case .tuesday:
            return 3
        case .wednesday:
            return 4
        case .thursday:
            return 5
        case .friday:
            return 6
        case .saturday:
            return 7
        case .sunday:
            return 1
        }
    }
}
