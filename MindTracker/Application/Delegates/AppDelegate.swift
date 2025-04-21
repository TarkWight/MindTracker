//
//  AppDelegate.swift
//  MindTracker
//
//  Created by Tark Wight on 21.02.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let appFactory = AppFactory()

    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .appGray
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().tintColor = UITheme.Colors.appWhite
        UITabBar.appearance().unselectedItemTintColor = UITheme.Colors.appGrayLight
        return true
    }
}
