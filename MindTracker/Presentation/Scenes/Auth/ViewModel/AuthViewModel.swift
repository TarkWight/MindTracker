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
    private let authService: AppleSignInServiceProtocol
    private let faceIDService: FaceIDServiceProtocol

    // MARK: - Properties

    var title: String = LocalizedKey.authTitle
    var buttonTitle: String = LocalizedKey.authButtonTitle

    // MARK: - Initializers

    init(
        coordinator: AuthCoordinatorProtocol,
        authService: AppleSignInServiceProtocol,
        faceIDService: FaceIDServiceProtocol
    ) {
        self.coordinator = coordinator
        self.authService = authService
        self.faceIDService = faceIDService
    }

    // MARK: - Public Methods

    func handle(_ event: LoginViewEvent) {
        Task {
            switch event {
            case .logInTapped:
                await logInTapped()
            }
        }
    }

    // MARK: - Private Methods
    private func logInTapped() async {
        do {
            if try await faceIDService.isFaceIDEnabled() {
                print("Face ID is enabled")
                coordinator.dismissAuthScreens()
                return
            }

            if await authService.isSessionActive() {
                print("Session is active")
                coordinator.dismissAuthScreens()
                return
            }

            _ = try await authService.signIn()
            print("User is signed in")
            coordinator.dismissAuthScreens()

        } catch {
            print("Authentication failed:", error)
        }
    }
}

enum LoginViewEvent {
    case logInTapped
}
