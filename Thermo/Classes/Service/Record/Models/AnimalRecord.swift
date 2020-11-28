//
//  AnimalRecord.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.11.2020.
//

struct AnimalRecord: Record, Hashable {
    let id: Int
    let member: Member
    let date: Date
    let temperature: Temperature
}

// MARK: Codable
extension AnimalRecord: Codable {}
