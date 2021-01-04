//
//  TemperatureManagerCore.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.10.2020.
//

import RxSwift

final class RecordManagerCore: RecordManager {
    struct Constants {
        static let cachedHumanRecordsKey = "record_manager_core_cached_human_records_key"
        static let cachedAnimalRecordsKey = "record_manager_core_cached_animal_records_key"
        static let cachedObjectRecordsKey = "record_manager_core_cached_objects_records_key"
    }
}

// MARK: API
extension RecordManagerCore {
    func log(human: Member,
             temperature: Temperature,
             overallFeeling: OverallFeeling,
             symptoms: [Symptom],
             medicines: [Medicine]) -> HumanRecord? {
        let humanRecord = HumanRecord(id: Int.random(in: 0..<Int.max),
                                      member: human,
                                      date: Date(),
                                      temperature: temperature,
                                      overallFeeling: overallFeeling,
                                      symptoms: symptoms,
                                      medicines: medicines)
        
        var humanRecords = getHumanRecords()
        humanRecords.append(humanRecord)
        
        guard store(humanRecords: humanRecords) else {
            return nil
        }
        
        RecordManagerMediator.shared.notifyAboutLogged(record: humanRecord)
        
        return humanRecord
    }
    
    func log(animal: Member,
             temperature: Temperature) -> AnimalRecord? {
        let animalRecord = AnimalRecord(id: Int.random(in: 0..<Int.max),
                                        member: animal,
                                        date: Date(),
                                        temperature: temperature)
        
        var animalRecords = getAnimalRecords()
        animalRecords.append(animalRecord)
        
        guard store(animalRecords: animalRecords) else {
            return nil
        }
        
        RecordManagerMediator.shared.notifyAboutLogged(record: animalRecord)
        
        return animalRecord
    }
    
    func log(object: Member,
             temperature: Temperature) -> ObjectRecord? {
        let objectRecord = ObjectRecord(id: Int.random(in: 0..<Int.max),
                                        member: object,
                                        date: Date(),
                                        temperature: temperature)
        
        var objectRecords = getObjectRecords()
        objectRecords.append(objectRecord)
        
        guard store(objectRecords: objectRecords) else {
            return nil
        }
        
        RecordManagerMediator.shared.notifyAboutLogged(record: objectRecord)
        
        return objectRecord
    }
    
    func remove(recordId: Int) {
        var humanRecords = getHumanRecords()
        humanRecords.removeAll(where: { $0.id == recordId })
        
        store(humanRecords: humanRecords)
        
        RecordManagerMediator.shared.notifyAboutRemoved(recordId: recordId)
    }
    
    func remove(memberId: Int) {
        var humanRecords = getHumanRecords()
        humanRecords.removeAll(where: { $0.member.id == memberId })
        
        store(humanRecords: humanRecords)
        
        RecordManagerMediator.shared.notifyAboutRemovedAllRecords(for: memberId)
    }
    
    func get(for memberId: Int) -> [Record] {
        getAllRecords()
            .filter { $0.member.id == memberId }
    }
    
    func get(recordId: Int) -> Record? {
        getAllRecords()
            .first(where: { $0.id == recordId })
    }
}

// MARK: API(Rx)
extension RecordManagerCore {
    func rxLog(human: Member,
               temperature: Temperature,
               overallFeeling: OverallFeeling,
               symptoms: [Symptom],
               medicines: [Medicine]) -> Single<HumanRecord?> {
        Single<HumanRecord?>
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                event(.success(this.log(human: human,
                                        temperature: temperature,
                                        overallFeeling: overallFeeling,
                                        symptoms: symptoms,
                                        medicines: medicines)))
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
    }
    
    func rxLog(animal: Member,
               temperature: Temperature) -> Single<AnimalRecord?> {
        Single<AnimalRecord?>
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                event(.success(this.log(animal: animal,
                                        temperature: temperature)))
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
    }
    
    func rxLog(object: Member,
               temperature: Temperature) -> Single<ObjectRecord?> {
        Single<ObjectRecord?>
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                event(.success(this.log(object: object,
                                        temperature: temperature)))
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
    }
    
    func rxRemove(recordId: Int) -> Completable {
        Completable
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                this.remove(recordId: recordId)
                
                event(.completed)
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
    }
    
    func rxRemove(memberId: Int) -> Completable {
        Completable
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                this.remove(memberId: memberId)
                
                event(.completed)
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
    }
    
    func rxGet(for memberId: Int) -> Single<[Record]> {
        Single<[Record]>
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                event(.success(this.get(for: memberId)))
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
    }
    
    func rxGet(recordId: Int) -> Single<Record?> {
        Single<Record?>
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                event(.success(this.get(recordId: recordId)))
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
    }
}

// MARK: Private
private extension RecordManagerCore {
    @discardableResult
    func store(humanRecords: [HumanRecord]) -> Bool {
        guard let data = try? JSONEncoder().encode(humanRecords) else {
            return false
        }
        
        UserDefaults.standard.setValue(data, forKeyPath: Constants.cachedHumanRecordsKey)
        
        return true
    }
    
    @discardableResult
    func store(animalRecords: [AnimalRecord]) -> Bool {
        guard let data = try? JSONEncoder().encode(animalRecords) else {
            return false
        }
        
        UserDefaults.standard.setValue(data, forKeyPath: Constants.cachedAnimalRecordsKey)
        
        return true
    }
    
    @discardableResult
    func store(objectRecords: [ObjectRecord]) -> Bool {
        guard let data = try? JSONEncoder().encode(objectRecords) else {
            return false
        }
        
        UserDefaults.standard.setValue(data, forKeyPath: Constants.cachedObjectRecordsKey)
        
        return true
    }
    
    func getAllRecords() -> [Record] {
        let humanRecords = getHumanRecords()
        let animalRecords = getAnimalRecords()
        let objectRecords = getObjectRecords()
        
        return humanRecords + animalRecords + objectRecords
    }
    
    func getHumanRecords() -> [HumanRecord] {
        guard
            let data = UserDefaults.standard.data(forKey: Constants.cachedHumanRecordsKey),
            let records = try? JSONDecoder().decode([HumanRecord].self, from: data)
        else {
            return []
        }
        
        return records
    }
    
    func getAnimalRecords() -> [AnimalRecord] {
        guard
            let data = UserDefaults.standard.data(forKey: Constants.cachedAnimalRecordsKey),
            let records = try? JSONDecoder().decode([AnimalRecord].self, from: data)
        else {
            return []
        }
        
        return records
    }
    
    func getObjectRecords() -> [ObjectRecord] {
        guard
            let data = UserDefaults.standard.data(forKey: Constants.cachedObjectRecordsKey),
            let records = try? JSONDecoder().decode([ObjectRecord].self, from: data)
        else {
            return []
        }
        
        return records
    }
}
