//
//  AuthService.swift
//  MindTracker
//
//  Created by Tark Wight on 03.07.2025.
//

import Foundation

final class AuthService: AuthServiceProtocol {
    private let biometry: BiometryServiceProtocol
    private let apple: AppleSignInServiceProtocol

    init(biometry: BiometryServiceProtocol, apple: AppleSignInServiceProtocol) {
        self.biometry = biometry
        self.apple = apple
    }

    func isSessionActive() async -> Bool {
        await apple.isSessionActive()
    }

    func isBiometryEnabled() async throws -> Bool {
        try await biometry.isBiometryEnabled()
    }

    func setBiometryEnabled(_ enabled: Bool) async throws {
        try await biometry.setBiometryEnabled(enabled)
    }

    func logIn() async throws {
        _ = try await apple.signIn()
    }

    func tryAutoLogin() async throws -> Bool {
        if try await biometry.isBiometryEnabled() {
            let type = biometry.availableBiometryType()
            guard type != .none else { return false }

            let reason: String = {
                switch type {
                case .faceID: return LocalizedKey.authenticateFaceId
                case .touchID: return LocalizedKey.authenticateTouchId
                case .none: return LocalizedKey.biometryUnavailable
                }
            }()

            let success = try await biometry.authenticate(reason: reason)
            if success {
                return await apple.isSessionActive()
            } else {
                return false
            }
        } else {
            return await apple.isSessionActive()
        }
    }
}
