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
    private let emotionStorageService: EmotionStorageServiceProtocol
    private let tagStorageService: TagStorageServiceProtocol

    // MARK: - Initializers
    init(appFactory: AppFactory) {
        self.appFactory = appFactory
        self.emotionStorageService = appFactory.emotionStorageService
        self.tagStorageService = appFactory.tagStorageService
    }
}

extension SceneFactory: AuthSceneFactory {
    func makeAuthScene(coordinator: AuthCoordinatorProtocol) -> AuthViewController {
        let viewModel = AuthViewModel(
            coordinator: coordinator,
            authService: appFactory.appleSignInService,
            faceIDService: appFactory.faceIDService,
        )
        return AuthViewController(viewModel: viewModel)
    }
}

extension SceneFactory: JournalSceneFactory {
    func makeJournalScene(coordinator: JournalCoordinatorProtocol) -> JournalViewController {
        let viewModel = JournalViewModel(coordinator: coordinator, storageService: emotionStorageService)
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
    func makeSaveNoteScene(coordinator: SaveNoteCoordinatorProtocol, emotion: EmotionCard) -> SaveNoteViewController {
        let viewModel = SaveNoteViewModel(
            coordinator: coordinator,
            emotion: emotion,
            storageService: emotionStorageService,
            tagStorageService: tagStorageService
        )
        return SaveNoteViewController(viewModel: viewModel)
    }
}

extension SceneFactory: StatisticsSceneFactory {
    func makeStatisticsScene(coordinator: StatisticsCoordinatorProtocol) -> StatisticsViewController {
        let viewModel = StatisticsViewModel(
            coordinator: coordinator,
            emotionStorageService: emotionStorageService,
        )
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
