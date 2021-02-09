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
        recordsManager
            .rxGetRecords()
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .map { records -> [JournalTableSection] in
                var array = [JournalTableSection]()
                
                let elements = records
                    .map { record -> JournalTableElement in
//                        let t = JTTemperature(feeling: record.feeling,
//                                            temperature: record.temperature,
//                                            date: record.date)
                        
//                        return .temperature(t)
                        
                        var tags = [String]()
                        record.medicines.forEach { m in
                            tags.append(m.name)
                            tags.append(m.name)
                            tags.append(m.name)
                            tags.append(m.name)
                        }
                        record.symptoms.forEach { s in
                            tags.append(s.name)
                            tags.append(s.name)
                            tags.append(s.name)
                            tags.append(s.name)
                        }
                        
                        let t = JTTemperatureWithTags(feeling: record.feeling,
                                                      temperature: record.temperature,
                                                      date: record.date,
                                                      tags: tags)
                        
                        return .temperatureWithTags(t)
                    }
                let section = JournalTableSection(title: "7 days",
                                                  elements: elements)
                
                array.append(section)
                array.append(section)
                array.append(section)
                array.append(section)
                array.append(section)
                array.append(section)
                array.append(section)
                array.append(section)
                array.append(section)
                
                return array
            }
            .observe(on: MainScheduler.asyncInstance)
            .asDriver(onErrorJustReturn: [])
    }
}
