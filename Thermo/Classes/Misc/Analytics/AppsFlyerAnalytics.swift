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
        AppsFlyerLib.shared().appleAppID = "1537374470"
    }
    
    func applicationDidBecomeActive() {
        AppsFlyerLib.shared().start()
    }
}
