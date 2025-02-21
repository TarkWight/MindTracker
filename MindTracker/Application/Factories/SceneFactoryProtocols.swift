//
//  SceneFactoryProtocols.swift
//  MindTracker
//
//  Created by Tark Wight on 21.02.2025.
//

import UIKit

@MainActor
protocol AuthSceneFactory {
    func makeAuthViewController(coordinator: AuthCoordinatorProtocol) -> AuthViewController
}
    
