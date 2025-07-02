//
//  SettingsCoordinator.swift
//  MindTracker
//
//  Created by Tark Wight on 23.02.2025.
//

import UIKit

@MainActor
protocol SettingsCoordinatorProtocol: Coordinator {}

final class SettingsCoordinator: SettingsCoordinatorProtocol, ChildCoordinator {
    var navigationController: UINavigationController
    weak var parent: ParentCoordinator?
    var viewControllerRef: UIViewController?
    private let sceneFactory: SceneFactory

    init(
        navigationController: UINavigationController,
        parent: ParentCoordinator?,
        sceneFactory: SceneFactory
    ) {
        self.navigationController = navigationController
        self.parent = parent
        self.sceneFactory = sceneFactory
    }

    func start(animated: Bool) {
        let settingsVC = sceneFactory.makeSettingsScene(coordinator: self)
        viewControllerRef = settingsVC
        settingsVC.viewModel.coordinator = self
        settingsVC.tabBarItem = UITabBarItem(
            title: LocalizedKey.tabBarSettings,
            image: AppIcons.tabBarSettings,
            selectedImage: nil
        )

        navigationController.pushViewController(settingsVC, animated: animated)
    }

    func coordinatorDidFinish() {
        parent?.childDidFinish(self)
    }
}
