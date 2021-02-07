//
//  Medicine.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 21.11.2020.
//

struct Medicine {
    let id: Int
    let name: String
}

// MARK: Codable
extension Medicine: Codable {}

// MARK: Hashable
extension Medicine: Hashable {}
