//
//  AppCoordinator.swift
//  MindTracker
//
//  Created by Tark Wight on 21.02.2025.
//

import UIKit

@MainActor
final class AppCoordinator {
    private let window: UIWindow
    private let navigationController: UINavigationController
    private let sceneFactory: SceneFactory
    
    // MARK: - Initializer
    init(window: UIWindow, sceneFactory: SceneFactory) {
        self.window = window
        self.navigationController = UINavigationController()
        self.sceneFactory = sceneFactory
        
        setupRootViewController()
    }
    
    // MARK: - Private
    private func setupRootViewController() {
        let viewController = ViewController()
        navigationController.viewControllers = [viewController]
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
