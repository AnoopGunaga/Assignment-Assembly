//
//  AppDelegate.swift
//  RedditPicsBrowser-iOS
//
//  Created by Anoop Gunaga on 01/10/21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(
        _ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        guard let homeVC = HomeViewController.create() else { return false }
        
        let navigationController = UINavigationController(rootViewController: homeVC)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}

