//
//  AppCoordinator.swift
//  MindTracker
//
//  Created by Tark Wight on 21.02.2025.
//

import UIKit

final class AppCoordinator: ParentCoordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    private let sceneFactory: SceneFactory

    init(
        navigationController: UINavigationController,
        sceneFactory: SceneFactory
    ) {
        self.navigationController = navigationController
        self.sceneFactory = sceneFactory
    }

    func start(animated: Bool) {
        showAuthFlow(animated: animated)
    }

    private func showAuthFlow(animated: Bool) {
        let authCoordinator = AuthCoordinator(
            navigationController: navigationController,
            parent: self,
            sceneFactory: sceneFactory
        )
        addChild(authCoordinator)
        authCoordinator.start(animated: animated)
    }

    private func showMainFlow(animated: Bool) {
        let tabBarCoordinator = TabBarCoordinator(
            navigationController: navigationController,
            parent: self,
            sceneFactory: sceneFactory
        )
        addChild(tabBarCoordinator)
        tabBarCoordinator.start(animated: animated)
    }
}

extension AppCoordinator {
    func childDidFinish(_ child: Coordinator?) {
        if let child = child {
            if let index = childCoordinators.firstIndex(where: { $0 === child }) {
                childCoordinators.remove(at: index)
            }

            if child is AuthCoordinator {
                showMainFlow(animated: true)
            }
        }
    }
}
