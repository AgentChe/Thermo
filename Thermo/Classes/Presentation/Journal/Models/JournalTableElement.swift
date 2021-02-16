//
//  JournalTableElement.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 08.02.2021.
//

import Foundation

enum JournalTableElement {
    case temperature(JTTemperature)
    case temperatureWithTags(JTTemperatureWithTags)
}

struct JTTemperature {
    let feeling: Feeling
    let temperature: Temperature
    let date: Date
}

struct JTTemperatureWithTags {
    let feeling: Feeling
    let temperature: Temperature
    let date: Date
    let tags: [String]
}
