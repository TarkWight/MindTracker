//
//  SceneFactoryProtocols.swift
//  MindTracker
//
//  Created by Tark Wight on 21.02.2025.
//

import UIKit

@MainActor
protocol AuthSceneFactory {
    func makeAuthScene(coordinator: AuthCoordinatorProtocol) -> AuthViewController
}

@MainActor
protocol JournalSceneFactory {
    func makeJournalScene(coordinator: JournalCoordinatorProtocol) -> JournalViewController
}

@MainActor
protocol AddNoteSceneFactory {
    func makeAddNoteScene(coordinator: AddNoteCoordinatorProtocol) -> AddNoteViewController
}

@MainActor
protocol SaveNoteSceneFactory {
    func makeSaveNoteScene(coordinator: SaveNoteCoordinatorProtocol, emotionType: EmotionType) -> SaveNoteViewController
}

@MainActor
protocol StatisticsSceneFactory {
    func makeStatisticsScene(coordinator: StatisticsCoordinatorProtocol) -> StatisticsViewController
}

@MainActor
protocol SettingsSceneFactory {
    func makeSettingsScene(coordinator: SettingsCoordinatorProtocol) -> SettingsViewController
}
