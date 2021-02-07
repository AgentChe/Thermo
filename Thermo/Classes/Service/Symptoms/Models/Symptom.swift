//
//  Symptom.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 21.11.2020.
//

struct Symptom {
    let id: Int
    let name: String
}

// MARK: Codable
extension Symptom: Codable {}

// MARK: Hashable
extension Symptom: Hashable {}
