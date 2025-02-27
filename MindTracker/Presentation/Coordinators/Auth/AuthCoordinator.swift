//
//  AuthCoordinator.swift
//  MindTracker
//
//  Created by Tark Wight on 22.02.2025.
//

import Foundation
import UIKit

final class AuthCoordinator: ParentCoordinator {
    
    var parent: RootCoordinator?
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(animated: Bool = false) {
        
    }
    
    func dismissAuthScreens() {
        parent?.baseTabBarController?.hideNavigationController()
        
        let lastCoordinator = childCoordinators.popLast()
        for item in childCoordinators.reversed() {
            if item is ChildCoordinator {
                let childCoordinator = item as! ChildCoordinator
                if let viewController = childCoordinator.viewControllerRef as? DisposableViewController {
                    viewController.cleanUp()
                }
                childCoordinator.viewControllerRef?.navigationController?.popViewController(animated: false)
                self.childDidFinish(childCoordinator)
            }
        }
        lastCoordinator?.popViewController(animated: true, useCustomAnimation: true)
        navigationController.customPopToRootViewController()
    }
    
}
    
