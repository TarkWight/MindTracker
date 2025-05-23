//
//  JournalCoordinator.swift
//  MindTracker
//
//  Created by Tark Wight on 22.02.2025.
//

import UIKit

@MainActor
protocol JournalCoordinatorProtocol: Coordinator {
    func showAddNote()
    func didEmotionTapped(with emotion: EmotionCard)
    func cleanUpZombieCoordinators()
    func coordinatorDidFinish()
    func dismissNoteScreen()
}

final class JournalCoordinator: JournalCoordinatorProtocol, ParentCoordinator, ChildCoordinator {
    var viewControllerRef: UIViewController?

    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var parent: TabBarCoordinator?
    private let sceneFactory: SceneFactory

    init(navigationController: UINavigationController, parent: TabBarCoordinator?, sceneFactory: SceneFactory) {
        self.navigationController = navigationController
        self.parent = parent
        self.sceneFactory = sceneFactory
    }

    func start(animated: Bool) {
        let journalVC = sceneFactory.makeJournalScene(coordinator: self)
        viewControllerRef = journalVC
        journalVC.viewModel.coordinator = self
        journalVC.tabBarItem = UITabBarItem(
            title: LocalizedKey.tabBarJournal,
            image: AppIcons.tabBarJournal,
            selectedImage: nil
        )

        navigationController.pushViewController(journalVC, animated: animated)
    }

    func showAddNote() {
        parent?.addNoteScreen(navigationController: navigationController, animated: true, parent: self)
    }

    func didEmotionTapped(with emotion: EmotionCard) {
        let saveNoteCoordinator = SaveNoteCoordinator(
            navigationController: navigationController,
            parent: self,
            sceneFactory: sceneFactory
        )
        saveNoteCoordinator.configure(with: emotion)
        addChild(saveNoteCoordinator)
        saveNoteCoordinator.start(animated: true)
//        parent?.saveNoteScreen(navigationController: navigationController, animated: true, parent: self)
    }

    func coordinatorDidFinish() {
        parent?.childDidFinish(self)
    }

    func cleanUpZombieCoordinators() {
        parent?.baseTabBarController?.cleanUpZombieCoordinators()
    }

    func dismissNoteScreen() {
        parent?.baseTabBarController?.hideNavigationController()

        let lastCoordinator = childCoordinators.popLast()

        for item in childCoordinators.reversed() {
            if let childCoordinator = item as? ChildCoordinator {
                if let viewController = childCoordinator.viewControllerRef as? DisposableViewController {
                    viewController.cleanUp()
                }

                if let navController = childCoordinator.viewControllerRef?.navigationController {
                    navController.popViewController(animated: false)
                }

                childDidFinish(childCoordinator)
            }
        }

        lastCoordinator?.popViewController(animated: true, useCustomAnimation: true)
        navigationController.customPopToRootViewController()
    }
}
