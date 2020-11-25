//
//  Record.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 25.11.2020.
//

protocol Record {
    var id: Int { get }
    var member: Member { get }
    var date: Date { get }
    var temperature: Temperature { get }
}
