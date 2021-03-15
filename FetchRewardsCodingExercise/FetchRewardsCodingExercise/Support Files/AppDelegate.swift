// Copyright © 2021 Shawn James. All rights reserved.
// Created by Shawn James
// AppDelegate.swift

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }

        CoreDataStack.shared.removeExpired()

        return true
    }
}
