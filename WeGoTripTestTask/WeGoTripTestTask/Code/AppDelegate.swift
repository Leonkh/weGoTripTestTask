//
//  AppDelegate.swift
//  WeGoTripTestTask
//
//  Created by lr.habibullin on 17.03.2023.
//

import UIKit
import Swinject

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Properties
    
    var window: UIWindow?
    private lazy var applicationDIContainer = ApplicationDIContainer.shared
    
    
    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let mainView: MainView = applicationDIContainer.resolve()
        
        let navigationRootViewController = UINavigationController(rootViewController: mainView)
        window?.rootViewController = navigationRootViewController
        window?.makeKeyAndVisible()
        return true
    }
    
    
}

