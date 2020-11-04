//
//  Member.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.10.2020.
//

struct Member: Codable, Hashable {
    let id: Int
    let unit: MemberUnit
    let temperatureUnit: TemperatureUnit
    let imageKey: String
    let name: String
    
    init(id: Int,
         unit: MemberUnit,
         temperatureUnit: TemperatureUnit,
         imageKey: String,
         name: String) {
        self.id = id
        self.unit = unit
        self.temperatureUnit = temperatureUnit
        self.imageKey = imageKey
        self.name = name 
    }
}
