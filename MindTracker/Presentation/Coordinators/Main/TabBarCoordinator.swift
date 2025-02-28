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

    init(navigationController: UINavigationController, parent: ParentCoordinator?, sceneFactory: SceneFactory) {
        self.navigationController = navigationController
        self.sceneFactory = sceneFactory
    }

    func start(animated: Bool) {
        baseTabBarController = BaseTabBarController(coordinator: self, sceneFactory: sceneFactory)

        navigationController.pushViewController(baseTabBarController!, animated: animated)
    }
}
