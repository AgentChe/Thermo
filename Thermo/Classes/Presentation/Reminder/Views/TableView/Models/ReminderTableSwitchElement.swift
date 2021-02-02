//
//  ReminderTableSwitchElement.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 01.11.2020.
//

import RxCocoa

struct ReminderTableSwitchElement {
    let text: String
    let isOn: Bool
    
    let switched: ((Bool) -> Void)
}
