//
//  TabView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import UIKit

final class TabView: UIView {
    enum Tab {
        case log, list, reminder
    }
    
    lazy var separator = makeSeparator()
    lazy var temperatureLogItem = makeItem(image: "Tabs.Track", title: "Track")
    lazy var temperatureListItem = makeItem(image: "Tabs.Journal", title: "Journal")
    lazy var reminderItem = makeItem(image: "Tabs.Reminder", title: "Reminder")
    
    var selectedTab = Tab.list {
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
        [
            temperatureLogItem,
            temperatureListItem,
            reminderItem
        ]
        .forEach {
            $0.state = .deselected
        }
        
        switch selectedTab {
        case .log:
            temperatureLogItem.state = .selected
        case .list:
            temperatureListItem.state = .selected
        case .reminder:
            reminderItem.state = .selected
        }
    }
}

// MARK: Make constraints
private extension TabView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1.scale),
            separator.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            temperatureLogItem.leadingAnchor.constraint(equalTo: leadingAnchor),
            temperatureLogItem.bottomAnchor.constraint(equalTo: bottomAnchor),
            temperatureLogItem.topAnchor.constraint(equalTo: topAnchor),
            temperatureLogItem.widthAnchor.constraint(equalTo: temperatureListItem.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            temperatureListItem.leadingAnchor.constraint(equalTo: temperatureLogItem.trailingAnchor),
            temperatureListItem.bottomAnchor.constraint(equalTo: bottomAnchor),
            temperatureListItem.topAnchor.constraint(equalTo: topAnchor),
            temperatureListItem.widthAnchor.constraint(equalTo: reminderItem.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            reminderItem.leadingAnchor.constraint(equalTo: temperatureListItem.trailingAnchor),
            reminderItem.trailingAnchor.constraint(equalTo: trailingAnchor),
            reminderItem.bottomAnchor.constraint(equalTo: bottomAnchor),
            reminderItem.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TabView {
    func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(integralRed: 237, green: 236, blue: 236)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeItem(image: String, title: String) -> TabItemView {
        let attrs = TextAttributes()
            .font(Fonts.Poppins.semiBold(size: 15.scale))
            .textColor(UIColor(integralRed: 199, green: 199, blue: 204))
            .letterSpacing(-0.4.scale)
            .lineHeight(20.scale)
            .textAlignment(.center)
        
        let view = TabItemView()
        view.backgroundColor = UIColor.clear
        view.imageView.image = UIImage(named: image)
        view.label.attributedText = title.localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
