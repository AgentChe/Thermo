//
//  RLTableElement.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 04.02.2021.
//

struct RLTableElement {
    let reminder: Reminder
    
    let switched: ((Bool) -> Void)
}
