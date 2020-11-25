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
}

// MARK: Codable
extension MemberUnit: Codable {
    private enum Keys: String, CodingKey {
        case human, cases
    }
    
    private enum Cases: String, Codable {
        case me, child, parent, other
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        let human = try container.decode(Human.self, forKey: .human)
        let cases = try container.decode(Cases.self, forKey: .cases)
        
        switch cases {
        case .me:
            self = .me(human)
        case .child:
            self = .child(human)
        case .parent:
            self = .parent(human)
        case .other:
            self = .other(human)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        let cases: Cases
        let human: Human
        
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
        }
        
        try container.encode(cases, forKey: .cases)
        try container.encode(human, forKey: .human)
    }
}
