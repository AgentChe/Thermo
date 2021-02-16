//
//  TemperatureManagerCore.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.10.2020.
//

import RxSwift

final class RecordManagerCore: RecordManager {
    struct Constants {
        static let cachedRecordsKey = "record_manager_core_cached_records_key"
    }
}

// MARK: API
extension RecordManagerCore {
    func log(temperature: Temperature,
             feeling: Feeling,
             medicines: [Medicine],
             symptoms: [Symptom]) -> Record? {
        let record = Record(id: Int.random(in: Int.min...Int.max),
                             date: Date(),
                             temperature: temperature,
                             feeling: feeling,
                             medicines: medicines,
                             symptoms: symptoms)
        
        var records = getRecords()
        records.append(record)
        
        guard let data = try? JSONEncoder().encode(records) else {
            return nil
        }
        
        UserDefaults.standard.setValue(data, forKey: Constants.cachedRecordsKey)
        
        RecordManagerMediator.shared.notifyAboutLogged(record: record)
        
        return record
    }
    
    func getRecords() -> [Record] {
        guard
            let data = UserDefaults.standard.data(forKey: Constants.cachedRecordsKey),
            let records = try? JSONDecoder().decode([Record].self, from: data)
        else {
            return []
        }
        
        return records
    }
}

// MARK: API(Rx)
extension RecordManagerCore {
    func rxLog(temperature: Temperature,
               feeling: Feeling,
               medicines: [Medicine],
               symptoms: [Symptom]) -> Single<Record?> {
        Single<Record?>
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                let record = this.log(temperature: temperature,
                                      feeling: feeling,
                                      medicines: medicines,
                                      symptoms: symptoms)
                
                event(.success(record))
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
    }
    
    func rxGetRecords() -> Single<[Record]> {
        Single<[Record]>
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                let records = this.getRecords()
                
                event(.success(records))
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
    }
}
