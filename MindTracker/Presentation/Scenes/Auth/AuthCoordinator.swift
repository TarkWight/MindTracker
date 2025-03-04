//
//  AuthCoordinator.swift
//  MindTracker
//
//  Created by Tark Wight on 22.02.2025.
//

import Foundation
import UIKit

protocol AuthCoordinatorProtocol: Coordinator {
    func dismissAuthScreens()
}

final class AuthCoordinator: AuthCoordinatorProtocol, ParentCoordinator {
    var parent: ParentCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    private let sceneFactory: SceneFactory

    init(navigationController: UINavigationController, parent: ParentCoordinator?, sceneFactory: SceneFactory) {
        self.navigationController = navigationController
        self.parent = parent
        self.sceneFactory = sceneFactory
    }

    func start(animated: Bool) {
        let authVC = sceneFactory.makeAuthScene(coordinator: self) 
        navigationController.pushViewController(authVC, animated: animated)
    }

    func coordinatorDidFinish() {
        parent?.childDidFinish(self)
    }
    
    func dismissAuthScreens() {
        parent?.childDidFinish(self)
        navigationController.popToRootViewController(animated: true)
    }
}
