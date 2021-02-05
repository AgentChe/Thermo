//
//  ReminderViewModel.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import RxSwift
import RxCocoa

final class ReminderViewModel {
    let addRemindAt = PublishRelay<Date>()
    let switchReminderTime = PublishRelay<(String, Bool)>()
    let switchReminderWeekday = PublishRelay<(Weekday, Bool)>()
    
    private let reminderManager = ReminderManagerCore()
    private let reminderNotificationsManager = ReminderNotificationsManager()
    
    func sections() -> Driver<[ReminderTableSection]> {
        Driver
            .combineLatest(
                remindAT(),
                daysOfTheWeek()
            )
            .map { [$0, $1] }
    }
    
    func subscriveOnChangesAndUpdateNotificationsTriggers() -> Signal<Never> {
        return .never()
//        .ne
//        Signal<Void>
//            .merge(
//                reminderManager.rxDidChangeTime.map { _ in Void() },
//                reminderManager.rxDidChangeWeekday.map { _ in Void() }
//            )
//            .flatMapLatest { [weak self] _ -> Signal<Reminders> in
//                guard let this = self else {
//                    return .empty()
//                }
//
//                return Single
//                    .zip(
//                        this.reminderManager.rxObtainRemindersTime(),
//                        this.reminderManager.rxObtainRemindersWeekday()
//                    )
//                    .map { times, weekdays -> Reminders in
//                        return Reminders(times: times.filter { $0.checked },
//                                         weekdays: weekdays.filter { $0.checked })
//                    }
//                    .asSignal(onErrorSignalWith: .empty())
//            }
//            .flatMap { [weak self] reminders in
//                guard let this = self else {
//                    return .empty()
//                }
//
//                return this.reminderNotificationsManager
//                    .rxPost(reminders: reminders)
//                    .asSignal(onErrorSignalWith: .empty())
//            }
    }
}

// MARK: Private
private extension ReminderViewModel {
    func remindAT() -> Driver<ReminderTableSection> {
//        reminderManager
//            .rxObtainRemindersTime()
//            .asDriver(onErrorJustReturn: [])
//            .flatMap { [weak self] cached -> Driver<[ReminderTime]> in
//                guard let this = self else {
//                    return .empty()
//                }
//
//                return Driver
//                    .merge([
//                        this.addRemindAt
//                            .flatMap { date -> Single<ReminderTime?> in
//                                this.reminderManager.rxAddRemindAt(time: date)
//                            }
//                            .asDriver(onErrorJustReturn: nil)
//                            .compactMap { $0 }
//                            .map { (0, $0) },
//
//                        this.switchReminderTime
//                            .asDriver(onErrorDriveWith: .empty())
//                            .flatMap {
//                                this.reminderManager
//                                    .rxSet(timeId: $0.0, checked: $0.1)
//                                    .asDriver(onErrorDriveWith: .never())
//                                    .flatMap { result -> Driver<(Int, ReminderTime)> in
//                                        .never()
//                                    }
//                            },
//
//                        this.reminderManager
//                            .rxDidChangeTime
//                            .map { (1, $0) }
//                            .asDriver(onErrorDriveWith: .empty())
//                    ])
//                    .scan(cached) { array, stub in
//                        let (step, time) = stub
//
//                        var result = array
//
//                        switch step {
//                        case 0:
//                            result.append(time)
//                        case 1:
//                            if let index = result.firstIndex(where: { $0.id == time.id }) {
//                                result[index] = time
//                            }
//                        default:
//                            break
//                        }
//
//                        return result
//                    }
//                    .startWith(cached)
//            }
//            .map { reminders -> ReminderTableSection in
//                let title = "Reminder.TimeTitle".localized
//                    .attributed(with: TextAttributes()
//                                    .textColor(UIColor(integralRed: 50, green: 50, blue: 52))
//                                    .font(Fonts.Poppins.bold(size: 28.scale))
//                                    .lineHeight(34.scale))
//
//                let timeFormatter = DateFormatter()
//                timeFormatter.dateFormat = "HH:mm"
//
//                let elements = reminders
//                    .map { time in
//                        ReminderTableSwitchElement(text: timeFormatter.string(from: time.time), isOn: time.checked, switched: { [weak self] isOn in
//                            self?.switchReminderTime.accept((time.id, isOn))
//                        })
//                    }
//
//                return ReminderTableSection(title: title, elements: elements)
//            }
        return .never()
    }
    
    func daysOfTheWeek() -> Driver<ReminderTableSection> {
//        reminderManager
//            .rxObtainRemindersWeekday()
//            .asDriver(onErrorJustReturn: [])
//            .flatMap { [weak self] cached -> Driver<[ReminderWeekday]> in
//                guard let this = self else {
//                    return .empty()
//                }
//
//                return Driver
//                    .merge([
//                        this.switchReminderWeekday
//                            .asDriver(onErrorDriveWith: .empty())
//                            .flatMap {
//                                this.reminderManager
//                                    .rxSet(weekday: $0.0, checked: $0.1)
//                                    .asDriver(onErrorDriveWith: .never())
//                                    .flatMap { result -> Driver<(Int, ReminderWeekday)> in
//                                        .never()
//                                    }
//                            },
//
//                        this.reminderManager
//                            .rxDidChangeWeekday
//                            .map { (1, $0) }
//                            .asDriver(onErrorDriveWith: .empty())
//                    ])
//                    .scan(cached) { array, stub in
//                        let (step, weekday) = stub
//
//                        var result = array
//
//                        switch step {
//                        case 0:
//                            result.append(weekday)
//                        case 1:
//                            if let index = result.firstIndex(where: { $0.weekday == weekday.weekday }) {
//                                result[index] = weekday
//                            }
//                        default:
//                            break
//                        }
//
//                        return result
//                    }
//                    .startWith(cached)
//            }
//            .map { weekdays -> ReminderTableSection in
//                let title = "Reminder.WeekdayTitle".localized
//                    .attributed(with: TextAttributes()
//                                    .textColor(UIColor(integralRed: 50, green: 50, blue: 52))
//                                    .font(Fonts.OpenSans.bold(size: 22.scale))
//                                    .lineHeight(28.scale))
//
//                let elements = weekdays
//                    .map { weekday in
//                        ReminderTableSwitchElement(text: WeekdayLocalizable.localize(weekday: weekday.weekday), isOn: weekday.checked, switched: { [weak self] isOn in
//                            self?.switchReminderWeekday.accept((weekday.weekday, isOn))
//                        })
//                    }
//
//                return ReminderTableSection(title: title, elements: elements)
//            }
        return .never()
    }
}
