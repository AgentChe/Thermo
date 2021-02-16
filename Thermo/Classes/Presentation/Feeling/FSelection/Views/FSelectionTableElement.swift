//
//  SymptomsTableElement.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 06.02.2021.
//

final class FSelectionTableElement {
    let id: Int
    let name: String
    var isSelected: Bool
    
    init(id: Int,
         name: String,
         isSelected: Bool) {
        self.id = id
        self.name = name
        self.isSelected = isSelected
    }
}
