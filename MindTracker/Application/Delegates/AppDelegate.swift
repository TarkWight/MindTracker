//
//  AppDelegate.swift
//  MindTracker
//
//  Created by Tark Wight on 21.02.2025.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AppStorage")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()

    lazy var appFactory: AppFactory = {
        AppFactory(persistentContainer: persistentContainer)
    }()

    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .appGray
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().tintColor = AppColors.appWhite
        UITabBar.appearance().unselectedItemTintColor = AppColors.appGrayLight
        return true
    }
}
