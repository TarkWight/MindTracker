//
//  SceneFactory.swift
//  MindTracker
//
//  Created by Tark Wight on 21.02.2025.
//

import Foundation


final class SceneFactory: AuthCoordinatorFactory, JournalCoordinatorFactory, AddNoteCoordinatorFactory, SaveNoteCoordinatorFactory, StatisticsCoordinatorFactory, SettingsCoordinatorFactory {
 
    
    
    private let appFactory: AppFactory

    init(appFactory: AppFactory) {
        self.appFactory = appFactory
    }
}

extension SceneFactory: AuthSceneFactory {
    func makeAuthScene(coordinator: AuthCoordinatorProtocol) -> AuthViewController {
        let viewModel = AuthViewModel(coordinator: coordinator)
        let viewControler = AuthViewController(viewModel: viewModel)
        return viewControler
    }
}

extension SceneFactory: JournalSceneFactory {
    func makeJournalScene(coordinator: JournalCoordinatorProtocol) -> JournalViewController {
        let viewModel = JournalViewModel(coordinator: coordinator)
        let viewController = JournalViewController(viewModel: viewModel)
        return viewController
    }
}

extension SceneFactory: AddNoteSceneFactory {
    func makeAddNoteScene(coordinator: AddNoteCoordinatorProtocol) -> AddNoteViewController {
        let viewModel = AddNoteViewModel(coordinator: coordinator)
        let viewController = AddNoteViewController(viewModel: viewModel)
        return viewController
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
        let viewModel = SettingsViewModel(coordinator: coordinator)
        return SettingsViewController(viewModel: viewModel)
    }
}
