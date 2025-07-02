//
//  AuthService.swift
//  MindTracker
//
//  Created by Tark Wight on 03.07.2025.
//

import Foundation

final class AuthService: AuthServiceProtocol {
    private let biometryService: BiometryServiceProtocol
    private let appleService: AppleSignInServiceProtocol

    init(
        biometryService: BiometryServiceProtocol,
        appleService: AppleSignInServiceProtocol
    ) {
        self.biometryService = biometryService
        self.appleService = appleService
    }

    func isSessionActive() async -> Bool {
        await appleService.isSessionActive()
    }

    func logIn() async throws {
        if try await biometryService.isBiometryEnabled() {
            let type = biometryService.availableBiometryType()

            guard type != .none else {
                throw AuthError.biometryUnavailable
            }

            let reason: String
            switch type {
            case .faceID: reason = LocalizedKey.authenticateFaceId
            case .touchID: reason = LocalizedKey.authenticateTouchId
            case .none: reason = LocalizedKey.biometryUnavailable
            }

            let success = try await biometryService.authenticate(reason: reason)
            guard success else {
                throw AuthError.biometryFailed
            }

            return
        }

        _ = try await appleService.signIn()
    }
}
