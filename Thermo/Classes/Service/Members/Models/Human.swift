//
//  Human.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 25.11.2020.
//

struct Human: Hashable {
    let name: String
    let imageKey: String
    let gender: Gender
    let dateBirthday: Date
}

// MARK: Codable
extension Human: Codable {}
