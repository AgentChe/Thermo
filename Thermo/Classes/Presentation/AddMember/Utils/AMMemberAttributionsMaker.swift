//
//  AMMemberMaker.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 26.11.2020.
//

import UIKit

final class AMMemberAttributionsMaker {
    typealias AMMemberAttributions = (MemberUnit, TemperatureUnit)
    
    var memberUnit: AMMemberUnit?
    var gender: Gender?
    var temperatureUnit: TemperatureUnit?
    var imageKey: String?
    var name: String?
    var dateBirthday: Date?
    
    private weak var vc: AddMemberViewController?
    
    init(vc: AddMemberViewController) {
        self.vc = vc
    }
}

// MARK: API
extension AMMemberAttributionsMaker {
    func makeAttributions() -> AMMemberAttributions? {
        guard let memberUnit = self.memberUnit else {
            return nil
        }
        
        guard let temperatureUnit = self.temperatureUnit else {
            return nil
        }
        
        switch memberUnit {
        case .me:
            guard let human = makeHuman() else {
                return nil
            }
            
            return (MemberUnit.me(human), temperatureUnit)
        case .child:
            guard let human = makeHuman() else {
                return nil
            }
            
            return (MemberUnit.child(human), temperatureUnit)
        case .parent:
            guard let human = makeHuman() else {
                return nil
            }
            
            return (MemberUnit.parent(human), temperatureUnit)
        case .other:
            guard let human = makeHuman() else {
                return nil
            }
            
            return (MemberUnit.other(human), temperatureUnit)
        case .animal:
            guard let animal = makeAnimal() else {
                return nil
            }
            
            return (MemberUnit.animal(animal), temperatureUnit)
        case .object:
            guard let object = makeObject() else {
                return nil
            }
            
            return (MemberUnit.object(object), temperatureUnit)
        }
    }
}

// MARK: Private
private extension AMMemberAttributionsMaker {
    func makeHuman() -> Human? {
        guard
            let gender = self.gender,
            let imageKey = self.imageKey,
            let name = self.name,
            let dateBirthday = self.dateBirthday
        else {
            return nil
        }
        
        return Human(name: name,
                     imageKey: imageKey,
                     gender: gender,
                     dateBirthday: dateBirthday)
    }
    
    func makeAnimal() -> Animal? {
        guard let name = self.name else {
            return nil
        }
        
        return Animal(name: name)
    }
    
    func makeObject() -> Object? {
        guard let name = self.name else {
            return nil
        }
        
        return Object(name: name)
    }
}
