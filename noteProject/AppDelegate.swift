//
//  AppDelegate.swift
//  noteProject
//
//  Created by mac on 18/5/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
                   window?.rootViewController = TestViewController()
                   window?.makeKeyAndVisible()
        return true
    }


}

