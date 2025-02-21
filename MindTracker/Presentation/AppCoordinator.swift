//
//  AppCoordinator.swift
//  MindTracker
//
//  Created by Tark Wight on 21.02.2025.
//

import UIKit

@MainActor
final class AppCoordinator {

    // MARK: - Properties
    private let window: UIWindow
    private let navigationController: UINavigationController
    private let sceneFactory: SceneFactory

    // MARK: - Initializer
    init(window: UIWindow, sceneFactory: SceneFactory) {
        self.window = window
        self.navigationController = UINavigationController()
        self.sceneFactory = sceneFactory

        configureRootViewController()
    }

    // MARK: - Private Methods
    private func configureRootViewController() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        showAuthScene()
    }


    // MARK: - Public Methods
    func showAuthScene() {
        let authCoordinator = AuthCoordinator(
            navigationController: navigationController,
            factory: sceneFactory
        )
        authCoordinator.showAuth()
    }


}
