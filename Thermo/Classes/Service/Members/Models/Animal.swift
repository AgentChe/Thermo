//
//  Animal.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 26.11.2020.
//

struct Animal: Hashable {
    let name: String
}

// MARK: Codable
extension Animal: Codable {}
