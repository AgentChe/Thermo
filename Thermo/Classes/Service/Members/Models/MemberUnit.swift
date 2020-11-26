//
//  MemberUnit.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.10.2020.
//

enum MemberUnit: Hashable {
    case me(Human)
    case child(Human)
    case parent(Human)
    case other(Human)
    case animal(Animal)
    case object(Object)
}

// MARK: Codable
extension MemberUnit: Codable {
    private enum Keys: String, CodingKey {
        case value, cases
    }
    
    private enum Cases: String, Codable {
        case me, child, parent, other, animal, object
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        let cases = try container.decode(Cases.self, forKey: .cases)
        
        switch cases {
        case .me:
            self = .me(try container.decode(Human.self, forKey: .value))
        case .child:
            self = .child(try container.decode(Human.self, forKey: .value))
        case .parent:
            self = .parent(try container.decode(Human.self, forKey: .value))
        case .other:
            self = .other(try container.decode(Human.self, forKey: .value))
        case .animal:
            self = .animal(try container.decode(Animal.self, forKey: .value))
        case .object:
            self = .object(try container.decode(Object.self, forKey: .value))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        let cases: Cases
        var human: Human?
        var animal: Animal?
        var object: Object?
        
        switch self {
        case .me(let value):
            cases = .me
            human = value
        case .child(let value):
            cases = .child
            human = value
        case .parent(let value):
            cases = .parent
            human = value
        case .other(let value):
            cases = .other
            human = value
        case .animal(let value):
            cases = .animal
            animal = value
        case .object(let value):
            cases = .object
            object = value
        }
        
        try container.encode(cases, forKey: .cases)
        
        if let _human = human {
            try container.encode(_human, forKey: .value)
        } else if let _animal = animal {
            try container.encode(_animal, forKey: .value)
        } else if let _object = object {
            try container.encode(_object, forKey: .value)
        }
    }
}
