//
//  AuthCoordinator.swift
//  MindTracker
//
//  Created by Tark Wight on 21.02.2025.
//

import UIKit

@MainActor
protocol AuthCoordinatorProtocol: AnyObject {
    func showAuth()
}

@MainActor
final class AuthCoordinator {
    private let navigationController: UINavigationController
    private let factory: SceneFactory
    
    init(navigationController: UINavigationController, factory: SceneFactory) {
        self.navigationController = navigationController
        self.factory = factory
        showAuth()
    }
    
}

extension AuthCoordinator: AuthCoordinatorProtocol {
    func showAuth() {
        let authVC = factory.makeAuthViewController(coordinator: self)
        navigationController.setViewControllers([authVC], animated: false)
    }
}
    
