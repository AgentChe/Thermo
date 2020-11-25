//
//  JournalTableElement.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

enum JournalTableElement {
    case report(JTReport)
    case tags(JTTags)
}

struct JTReport {
    let date: Date
    let temperature: Double
    let unit: TemperatureUnit
    let overallFeeiling: OverallFeeling?
}

struct JTTags {
    enum Style {
        case medicines, symptoms
    }
    
    let style: Style
    let tags: [TagViewModel]
}
