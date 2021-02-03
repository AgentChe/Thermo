//
//  TabView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import UIKit

final class TabView: UIView {
    enum Tab {
        case reminder, feeling, journal
    }
    
    lazy var reminderItem = makeItem(image: "Tabs.Reminder")
    lazy var feelingItem = makeItem(image: "Tabs.Feeling")
    lazy var journalItem = makeItem(image: "Tabs.Journal")
    
    lazy var selectedTab = Tab.feeling {
        didSet {
            update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension TabView {
    func update() {
        reminderItem.isSelected = selectedTab == .reminder
        feelingItem.isSelected = selectedTab == .feeling
        journalItem.isSelected = selectedTab == .journal
    }
}

// MARK: Make constraints
private extension TabView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            reminderItem.leadingAnchor.constraint(equalTo: leadingAnchor),
            reminderItem.bottomAnchor.constraint(equalTo: bottomAnchor),
            reminderItem.topAnchor.constraint(equalTo: topAnchor),
            reminderItem.widthAnchor.constraint(equalTo: feelingItem.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            feelingItem.leadingAnchor.constraint(equalTo: reminderItem.trailingAnchor),
            feelingItem.bottomAnchor.constraint(equalTo: bottomAnchor),
            feelingItem.topAnchor.constraint(equalTo: topAnchor),
            feelingItem.widthAnchor.constraint(equalTo: journalItem.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            journalItem.leadingAnchor.constraint(equalTo: feelingItem.trailingAnchor),
            journalItem.trailingAnchor.constraint(equalTo: trailingAnchor),
            journalItem.bottomAnchor.constraint(equalTo: bottomAnchor),
            journalItem.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TabView {
    func makeItem(image: String) -> TabItemView {
        let view = TabItemView()
        view.backgroundColor = UIColor.clear
        view.imageView.image = UIImage(named: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
