//
//  SaveNoteCoordinator.swift
//  MindTracker
//
//  Created by Tark Wight on 23.02.2025.
//

import UIKit

@MainActor
protocol SaveNoteCoordinatorProtocol: Coordinator {
    func saveNote()
    func coordinatorDidFinish()
}

final class SaveNoteCoordinator: SaveNoteCoordinatorProtocol, ChildCoordinator {
    var navigationController: UINavigationController
    weak var parent: ParentCoordinator?
    var viewControllerRef: UIViewController?
    private let sceneFactory: SceneFactory
    private var emotion: EmotionCard?

    func configure(with emotion: EmotionCard) {
        self.emotion = emotion
    }

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
        guard let emotion else {
            assertionFailure("EmotionType not configured before start()")
            return
        }

        let saveNoteVC = sceneFactory.makeSaveNoteScene(
            coordinator: self,
            emotion: emotion
        )
        viewControllerRef = saveNoteVC
        navigationController.pushViewController(saveNoteVC, animated: animated)
    }

    func coordinatorDidFinish() {
        if let viewControllerRef,
            navigationController.viewControllers.contains(viewControllerRef) {
            navigationController.popViewController(animated: true)
        }
        parent?.childDidFinish(self)
    }

    func saveNote() {
        if let parent = parent as? AddNoteCoordinator {
            parent.dismissNoteScreen()
        } else if let parent = parent as? JournalCoordinator {
            parent.dismissNoteScreen()
        }

        coordinatorDidFinish()
    }
}
