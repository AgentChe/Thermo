//
//  JournalViewModel.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import RxSwift
import RxCocoa

final class JournalViewModel {
    lazy var filter = PublishRelay<JournalFilterView.Filter>()
    
    private lazy var recordsManager = RecordManagerCore()
    
    lazy var sections = makeSections()
}

// MARK: Private
private extension JournalViewModel {
    func makeSections() -> Driver<[JournalTableSection]> {
        let currentDate = Date()
        let calendar = Calendar.current
        let components: Set<Calendar.Component> = [.day, .month, .year]
        
        let initial = recordsManager
            .rxGetRecords()
            .asDriver(onErrorJustReturn: [])
        
        let updated = RecordManagerMediator.shared
            .rxLoggedRecord
            .flatMap { [weak self] void -> Driver<[Record]> in
                guard let this = self else {
                    return .empty()
                }
                
                return this.recordsManager
                    .rxGetRecords()
                    .asDriver(onErrorJustReturn: [])
            }
        
        let records = Driver<[Record]>
            .merge(initial, updated)
            .asObservable()
        
        // Отдельная группировка по датам и мапинг в модели
        // чтобы одно и тоже не делать при каждом переключении
        // фильтра
        let groupedElementsByDate = records
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .map { records -> [Date: [JournalTableElement]] in
                let initialValue = [Date: [JournalTableElement]]()
                let calendar = Calendar.current
                
                return records.reduce(into: initialValue) { (old, record) in
                    let components = calendar.dateComponents(components, from: record.date)
                    let date = calendar.date(from: components)!
                    let existing = old[date] ?? []
                    let element = Self.recordToElement(record: record)
                    old[date] = existing + [element]
                }
            }
        
        let elements = Observable
            .combineLatest(filter, groupedElementsByDate.asObservable())
            .map { filter, elements -> [JournalTableSection] in
                switch filter {
                case .none:
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd.MM.yy"
                    
                    return elements
                        .sorted { $0.key > $1.key }
                        .map { JournalTableSection(title: dateFormatter.string(from: $0), elements: $1) }
                case .today:
                    let todayComponents = calendar.dateComponents(components, from: currentDate)
                    let todayDate = calendar.date(from: todayComponents)!
                    
                    return elements[todayDate].map { [JournalTableSection(title: "Journal.Calendar.Today".localized, elements: $0)] } ?? []
                case .days7:
                    let todayComponents = calendar.dateComponents(components, from: currentDate)
                    let todayDate = calendar.date(from: todayComponents)!
                    let days7Before = calendar.date(byAdding: .day, value: -7, to: todayDate)!
                    let dateInterval = DateInterval(start: days7Before, end: todayDate)
                    
                    let elements = elements
                        .compactMap { dateInterval.contains($0.key) ? $0 : nil }
                        .sorted { $0.key > $1.key }
                        .flatMap { $0.value }
                    
                    return !elements.isEmpty
                        ? [JournalTableSection(title: "Journal.Calendar.7Days".localized, elements: elements)]
                        : []
                    
                case .days30:
                    let todayComponents = calendar.dateComponents(components, from: currentDate)
                    let todayDate = calendar.date(from: todayComponents)!
                    let days30Before = calendar.date(byAdding: .day, value: -30, to: todayDate)!
                    let dateInterval = DateInterval(start: days30Before, end: todayDate)
                    
                    let elements = elements
                        .compactMap { dateInterval.contains($0.key) ? $0 : nil }
                        .sorted { $0.key > $1.key }
                        .flatMap { $0.value }
                    
                    return !elements.isEmpty
                        ? [JournalTableSection(title: "Journal.Calendar.30Days".localized, elements: elements)]
                        : []
                case let .custom(value):
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd.MM.yy"
                    
                    let dateComponents = calendar.dateComponents(components, from: value)
                    let customDate = calendar.date(from: dateComponents)!
                    
                    return elements[customDate].map { [JournalTableSection(title: dateFormatter.string(from: customDate), elements: $0)] } ?? []
                }
            }
        
        return elements
            .observe(on: MainScheduler.asyncInstance)
            .asDriver(onErrorJustReturn: [])
    }
    
    static func recordToElement(record: Record) -> JournalTableElement {
        let tags = record.medicines.map { $0.name } + record.symptoms.map { $0.name }
        
        if !tags.isEmpty {
            return .temperatureWithTags(
                JTTemperatureWithTags(
                    feeling: record.feeling,
                    temperature: record.temperature,
                    date: record.date,
                    tags: tags
                )
            )
        } else {
            return .temperature(
                JTTemperature(
                    feeling: record.feeling,
                    temperature: record.temperature,
                    date: record.date
                )
            )
        }
    }
}
