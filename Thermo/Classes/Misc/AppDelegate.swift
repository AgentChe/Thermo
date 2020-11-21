//
//  AppDelegate.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 26.10.2020.
//

import UIKit
import RxCocoa
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    private let generateStepInSplash = PublishRelay<Void>()
    
    private let sdkProvider = SDKProvider()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = SplashViewController.make(generateStep: generateStepInSplash.asSignal())
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        FirebaseApp.configure()
        
        runProvider(on: vc.view)
        
        sdkProvider.application(application, didFinishLaunchingWithOptions: launchOptions)
        SDKStorage.shared.pushNotificationsManager.application(didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        sdkProvider.application(app, open: url, options: options)
        
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        sdkProvider.application(application, continue: userActivity, restorationHandler: restorationHandler)
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        SDKStorage.shared.pushNotificationsManager.application(didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        SDKStorage.shared.pushNotificationsManager.application(didFailToRegisterForRemoteNotificationsWithError: error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        SDKStorage.shared.pushNotificationsManager.application(didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
    }
}

// MARK: Private
private extension AppDelegate {
    func runProvider(on view: UIView) {
        let settings = SDKSettings(backendBaseUrl: GlobalDefinitions.sdkDomainUrl,
                                   backendApiKey: GlobalDefinitions.sdkApiKey,
                                   amplitudeApiKey: GlobalDefinitions.amplitudeApiKey,
                                   facebookActive: true,
                                   branchActive: false,
                                   firebaseActive: true,
                                   applicationTag: GlobalDefinitions.applicationTag,
                                   userToken: nil,
                                   userId: nil,
                                   view: view,
                                   shouldAddStorePayment: false,
                                   isTest: false)
        
        sdkProvider.initialize(settings: settings) { [weak self] in
            self?.generateStepInSplash.accept(Void())
        }
    }
}
