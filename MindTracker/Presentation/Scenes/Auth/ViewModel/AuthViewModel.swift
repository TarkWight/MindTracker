//
//  AuthViewModel.swift
//  MindTracker
//
//  Created by Tark Wight on 21.02.2025.
//

import Foundation

final class AuthViewModel: ViewModel {

    // MARK: - Properties

    var title: String = LocalizedKey.authTitle
    var buttonTitle: String = LocalizedKey.authButtonTitle

    private let coordinator: AuthCoordinatorProtocol

    init(coordinator: AuthCoordinatorProtocol) {
        self.coordinator = coordinator
    }

    func handle(_ event: LoginViewEvent) {
        switch event {
        case .logInTapped:
            logInTapped()
        }
    }
}

private extension AuthViewModel {
    func logInTapped() {
        coordinator.dismissAuthScreens()
    }
}

enum LoginViewEvent {
    case logInTapped
}
