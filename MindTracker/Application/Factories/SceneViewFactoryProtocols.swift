//
//  SceneViewFactoryProtocols.swift
//  MindTracker
//
//  Created by Tark Wight on 21.02.2025.
//

import Foundation

protocol AuthCoordinatorFactory: AuthSceneFactory {}
    
protocol JournalCoordinatorFactory: JournalSceneFactory {}

protocol AddNoteCoordinatorFactory: AddNoteSceneFactory {}

protocol SaveNoteCoordinatorFactory: SaveNoteSceneFactory {}

protocol StatisticsCoordinatorFactory: StatisticsSceneFactory {}

protocol SettingsCoordinatorFactory: SettingsSceneFactory {}



