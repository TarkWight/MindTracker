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

    // MARK: - Initializers

    init(coordinator: AuthCoordinatorProtocol) {
        self.coordinator = coordinator
    }

    // MARK: - Public Methods

    func handle(_ event: LoginViewEvent) {
        switch event {
        case .logInTapped:
            logInTapped()
        }
    }

    // MARK: - Private Methods
    private func logInTapped() {
        coordinator.dismissAuthScreens()
    }
}

enum LoginViewEvent {
    case logInTapped
}
