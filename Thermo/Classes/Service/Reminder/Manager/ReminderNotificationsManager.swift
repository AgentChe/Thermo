//
//  ReminderNotificationsManager.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 03.11.2020.
//

import RxSwift

final class ReminderNotificationsManager {
    private let center = UNUserNotificationCenter.current()
    
    func rxPost(reminders: [Reminder]) -> Single<Void> {
        Single<Void>
            .create { [weak self] event in
                self?.post(reminders: reminders)
                
                event(.success(Void()))
                
                return Disposables.create()
            }
    }
    
    func post(reminders: [Reminder]) {
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
                content.body = "Reminder.Notification.Body".localized
                content.sound = UNNotificationSound.default
                
                let unTrigger = UNCalendarNotificationTrigger(dateMatching: trigger.dateComponents, repeats: true)
                
                return UNNotificationRequest(identifier: trigger.id, content: content, trigger: unTrigger)
            }
    }
    
    func getTriggers(from reminders: [Reminder]) -> [Trigger] {
        reminders
            .map { reminder -> Trigger in
                var components = DateComponents()
                components.hour = Calendar.current.component(.hour, from: reminder.time)
                components.minute = Calendar.current.component(.minute, from: reminder.time)
                components.weekday = self.weekday(reminder.weekday)
                
                let id = String(format: "%%_%@", reminder.id, String(describing: reminder.weekday))
                
                return Trigger(id: id,
                               dateComponents: components)
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
