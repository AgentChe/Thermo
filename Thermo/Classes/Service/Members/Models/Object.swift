//
//  Object.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 26.11.2020.
//

struct Object: Hashable {
    let name: String
}

// MARK: Codable
extension Object: Codable {}
