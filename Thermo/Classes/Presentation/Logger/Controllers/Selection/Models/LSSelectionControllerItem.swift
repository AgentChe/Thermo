//
//  LSSelectionControllerItem.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 11.12.2020.
//

final class LSSelectionControllerItem {
    weak var viewItem: LoggerSelectionViewItem?
    var isSelected: Bool
    var name: String
    
    init(viewItem: LoggerSelectionViewItem) {
        self.viewItem = viewItem
        isSelected = viewItem.isSelected
        name = viewItem.name
    }
}
