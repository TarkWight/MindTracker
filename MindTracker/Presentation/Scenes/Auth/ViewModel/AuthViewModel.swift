//
//  AuthViewModel.swift
//  MindTracker
//
//  Created by Tark Wight on 21.02.2025.
//

import Foundation

final class AuthViewModel: ViewModel {

    // MARK: Dependencies

    private let coordinator: AuthCoordinatorProtocol
    private let authService: AuthServiceProtocol

    // MARK: - Properties

    var title: String = LocalizedKey.authTitle
    var buttonTitle: String = LocalizedKey.authButtonTitle
    var handle: ((LoginViewEvent) -> Void)?

    // MARK: - Initializers

    init(
        coordinator: AuthCoordinatorProtocol,
        authService: AuthServiceProtocol
    ) {
        self.coordinator = coordinator
        self.authService = authService
    }

    // MARK: - Public Methods

    func handle(_ event: LoginViewEvent) {
        switch event {
        case .logInTapped:
            Task {
                await logInTapped()
            }
        case let .showWebView(callback):
            self.handle?(.showWebView(callback))
        }
    }

    // MARK: - Private Methods
    private func logInTapped() async {
        do {
            try await authService.logIn()
            await MainActor.run {
                coordinator.dismissAuthScreens()
            }
        } catch {
            print("Authentication failed:", error)
        }
    }
}

enum LoginViewEvent {
    case logInTapped
    case showWebView(@Sendable () -> Void)
}
