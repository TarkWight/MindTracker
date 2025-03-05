//
//  TabBarCoordinator.swift
//  MindTracker
//
//  Created by Tark Wight on 22.02.2025.
//

import Foundation
import UIKit

final class TabBarCoordinator: NSObject, Coordinator, ParentCoordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var baseTabBarController: BaseTabBarController?
    let sceneFactory: SceneFactory

    init(navigationController: UINavigationController, parent _: ParentCoordinator?, sceneFactory: SceneFactory) {
        self.navigationController = navigationController
        self.sceneFactory = sceneFactory
    }

    func start(animated: Bool) {
        let tabBarController = BaseTabBarController(coordinator: self, sceneFactory: sceneFactory)
        baseTabBarController = tabBarController

        navigationController.pushViewController(tabBarController, animated: animated)
    }
}
