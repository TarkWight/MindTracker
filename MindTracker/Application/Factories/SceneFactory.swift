//
//  SceneFactory.swift
//  MindTracker
//
//  Created by Tark Wight on 21.02.2025.
//

import Foundation

final class SceneFactory:
    AuthCoordinatorFactory,
    JournalCoordinatorFactory,
    AddNoteCoordinatorFactory,
    SaveNoteCoordinatorFactory,
    StatisticsCoordinatorFactory,
    SettingsCoordinatorFactory {
    // MARK: - Properties
    private let appFactory: AppFactory
    private let storageService: EmotionStorageServiceProtocol

    // MARK: - Initializers
    init(appFactory: AppFactory, storageService: EmotionStorageServiceProtocol) {
        self.appFactory = appFactory
        self.storageService = storageService
    }
}

extension SceneFactory: AuthSceneFactory {
    func makeAuthScene(coordinator: AuthCoordinatorProtocol) -> AuthViewController {
        let viewModel = AuthViewModel(coordinator: coordinator)
        return AuthViewController(viewModel: viewModel)
    }
}

extension SceneFactory: JournalSceneFactory {
    func makeJournalScene(coordinator: JournalCoordinatorProtocol) -> JournalViewController {
        let viewModel = JournalViewModel(coordinator: coordinator)
        return JournalViewController(viewModel: viewModel)
    }
}

extension SceneFactory: AddNoteSceneFactory {
    func makeAddNoteScene(coordinator: AddNoteCoordinatorProtocol) -> AddNoteViewController {
        let viewModel = AddNoteViewModel(coordinator: coordinator)
        return AddNoteViewController(viewModel: viewModel)
    }
}

extension SceneFactory: SaveNoteSceneFactory {
    func makeSaveNoteScene(coordinator: SaveNoteCoordinatorProtocol) -> SaveNoteViewController {
        let viewModel = SaveNoteViewModel(coordinator: coordinator)
        return SaveNoteViewController(viewModel: viewModel)
    }
}

extension SceneFactory: StatisticsSceneFactory {
    func makeStatisticsScene(coordinator: StatisticsCoordinatorProtocol) -> StatisticsViewController {
        let viewModel = StatisticsViewModel(coordinator: coordinator)
        return StatisticsViewController(viewModel: viewModel)
    }
}

extension SceneFactory: SettingsSceneFactory {
    func makeSettingsScene(coordinator: SettingsCoordinatorProtocol) -> SettingsViewController {
        let viewModel = SettingsViewModel(
            coordinator: coordinator,
            avatarService: appFactory.avatarService,
            reminderService: appFactory.reminderService,
            faceIDService: appFactory.faceIDService
        )
        return SettingsViewController(viewModel: viewModel)
    }
}
