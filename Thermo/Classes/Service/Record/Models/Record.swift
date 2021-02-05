//
//  Record.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 25.11.2020.
//

struct Record {
    let id: Int
    let date: Date
    let temperature: Temperature
    let feeling: Feeling
    let medicines: [Medicine]
    let symptoms: [Symptom]
}

// MARK: Codable
extension Record: Codable {}
