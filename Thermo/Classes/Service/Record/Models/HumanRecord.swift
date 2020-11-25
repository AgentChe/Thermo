//
//  RecordHuman.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 25.11.2020.
//

struct HumanRecord: Record, Hashable, Codable {
    let id: Int
    let member: Member
    let date: Date
    let temperature: Temperature
    let overallFeeling: OverallFeeling
    let symptoms: [Symptom]
    let medicines: [Medicine]
}
