//
//  TabBarCoordinator+Ext.swift
//  MindTracker
//
//  Created by Tark Wight on 27.02.2025.
//

import UIKit

extension TabBarCoordinator {
    func journalScreen(
        navigationController: UINavigationController,
        animated: Bool
    ) {
        let journalCoordinator = JournalCoordinator(
            navigationController: navigationController,
            parent: self,
            sceneFactory: sceneFactory
        )
        addChild(journalCoordinator)
        journalCoordinator.start(animated: animated)
    }

    func settingsScreen(
        navigationController: UINavigationController,
        animated: Bool
    ) {
        let settingsCoordinator = SettingsCoordinator(
            navigationController: navigationController,
            parent: self,
            sceneFactory: sceneFactory
        )
        addChild(settingsCoordinator)
        settingsCoordinator.start(animated: animated)
    }

    func statisticsScreen(
        navigationController: UINavigationController,
        animated: Bool
    ) {
        let statisticsCoordinator = StatisticsCoordinator(
            navigationController: navigationController,
            parent: self,
            sceneFactory: sceneFactory
        )
        addChild(statisticsCoordinator)
        statisticsCoordinator.start(animated: animated)
    }

    func addNoteScreen(
        navigationController: UINavigationController,
        animated: Bool,
        parent: ParentCoordinator?
    ) {
        let addNoteCoordinator = AddNoteCoordinator(
            navigationController: navigationController,
            parent: parent,
            sceneFactory: sceneFactory
        )
        addChild(addNoteCoordinator)
        addNoteCoordinator.start(animated: animated)
    }

    func saveNoteScreen(
        navigationController: UINavigationController,
        animated: Bool,
        parent: ParentCoordinator?
    ) {
        let saveNoteCoordinator = SaveNoteCoordinator(
            navigationController: navigationController,
            parent: parent,
            sceneFactory: sceneFactory
        )
        addChild(saveNoteCoordinator)
        saveNoteCoordinator.start(animated: animated)
    }
}
