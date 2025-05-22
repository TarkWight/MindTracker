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
    var handle: ((LoginViewEvent) -> Void)?

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
            if try await faceIDService.isFaceIDEnabled() {
                print("Face ID is enabled")
                await MainActor.run {
                    self.coordinator.dismissAuthScreens()
                }
                return
            }

            if await authService.isSessionActive() {
                print("Session is active")
                await MainActor.run {
                    self.coordinator.dismissAuthScreens()
                }
                return
            }

        await MainActor.run {
            self.handle?(.showWebView {
                Task { @MainActor in
                    do {
                        _ = try await self.authService.signIn()
                        print("User is signed in")
                        self.coordinator.dismissAuthScreens()
                    } catch {
                        print("Sign in failed", error)
                    }
                }
            })
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
