//
//  AddNoteCoordinator.swift
//  MindTracker
//
//  Created by Tark Wight on 23.02.2025.
//

import UIKit

@MainActor
protocol AddNoteCoordinatorProtocol: Coordinator {
    func didSaveNoteTapped(with emotionType: EmotionType)
    func coordinatorDidFinish()
}

final class AddNoteCoordinator: AddNoteCoordinatorProtocol, ChildCoordinator, ParentCoordinator {
    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController
    weak var parent: ParentCoordinator?
    var viewControllerRef: UIViewController?
    private let sceneFactory: SceneFactory

    init(navigationController: UINavigationController, parent: ParentCoordinator?, sceneFactory: SceneFactory) {
        self.navigationController = navigationController
        self.parent = parent
        self.sceneFactory = sceneFactory
    }

    func start(animated: Bool) {
        let addNoteVC = sceneFactory.makeAddNoteScene(coordinator: self)
        viewControllerRef = addNoteVC
        navigationController.pushViewController(addNoteVC, animated: animated)
    }

    func showSaveNote(with emotionType: EmotionType) {
        let saveNoteCoordinator = SaveNoteCoordinator(
            navigationController: navigationController,
            parent: self,
            sceneFactory: sceneFactory
        )
        saveNoteCoordinator.configure(with: emotionType)
        addChild(saveNoteCoordinator)
        saveNoteCoordinator.start(animated: true)
    }

    func didSaveNoteTapped(with emotionType: EmotionType) {
        showSaveNote(with: emotionType)
    }

    func dismissNoteScreen() {
        if let parent = parent as? JournalCoordinator {
            parent.dismissNoteScreen()
        }
    }

    func coordinatorDidFinish() {
        parent?.childDidFinish(self)
    }
}
