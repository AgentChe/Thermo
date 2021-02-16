//
//  AppsFlyerAnalytics.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 11.01.2021.
//

import AppsFlyerLib

final class AppsFlyerAnalytics {
    static let shared = AppsFlyerAnalytics()
    
    private init() {}
}

// MARK: API
extension AppsFlyerAnalytics {
    func applicationDidFinishLaunchingWithOptions() {
        AppsFlyerLib.shared().appsFlyerDevKey = "DCciCfYXjMQ8QnkdCg8qzk"
        AppsFlyerLib.shared().appleAppID = "1553156412"
    }
    
    func applicationDidBecomeActive() {
        AppsFlyerLib.shared().start()
    }
    
    func set(userId: String) {
        AppsFlyerLib.shared().customerUserID = userId
    }
}
