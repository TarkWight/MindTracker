//
//  SceneFactory.swift
//  MindTracker
//
//  Created by Tark Wight on 21.02.2025.
//

import Foundation

final class SceneFactory {
    private let appFactory: AppFactory
    
    init(appFactory: AppFactory) {
        self.appFactory = appFactory
    }
}

extension SceneFactory: AuthCoordinatorFactory {
    func makeAuthViewController(coordinator: AuthCoordinatorProtocol) -> AuthViewController {
        let viewModel = AuthViewModel()
        let viewControler = AuthViewController(viewModel: viewModel)
        return viewControler
    }
}
