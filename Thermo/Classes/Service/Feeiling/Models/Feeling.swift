//
//  Feeling.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 05.02.2021.
//

enum Feeling: String {
    case good
    case sick
    case bad
    case recovered
}

// MARK: Codable
extension Feeling: Codable {}

// MARK: Hashable
extension Feeling: Hashable {}
