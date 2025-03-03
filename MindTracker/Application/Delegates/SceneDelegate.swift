//
//  SceneDelegate.swift
//  MindTracker
//
//  Created by Tark Wight on 21.02.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene),
              let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let window = UIWindow(windowScene: windowScene)
        window.backgroundColor = UITheme.Colors.background
        self.window = window

        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.view.backgroundColor = UITheme.Colors.background
        
        appCoordinator = AppCoordinator(
            navigationController: navigationController,
            sceneFactory: SceneFactory(appFactory: appDelegate.appFactory)
        )
        appCoordinator?.start(animated: false)

        navigationController.loadViewIfNeeded()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
