//
//  BiometryService.swift
//  MindTracker
//
//  Created by Tark Wight on 03.07.2025.
//

import LocalAuthentication

enum BiometryType {
    case none
    case touchID
    case faceID
}

final class BiometryService: BiometryServiceProtocol {
    private let key = "biometry_enabled"
    private let keychain: KeychainServiceProtocol

    init(keychain: KeychainServiceProtocol) {
        self.keychain = keychain
    }

    func isBiometryEnabled() async throws -> Bool {
        do {
            return try await keychain.loadBool(for: key)
        } catch {
            return false
        }
    }

    func setBiometryEnabled(_ enabled: Bool) async throws {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            print("Biometry not available:", error?.localizedDescription ?? "Unknown error")
            throw AuthError.biometryUnavailable
        }

        if enabled {
            let success = try await evaluateBiometry(context: context, reason: "Включить биометрию для входа")
            guard success else {
                throw AuthError.biometryFailed
            }
            try await keychain.save(true, for: key)
        } else {
            try await keychain.save(false, for: key)
        }
    }

    func authenticate(reason: String) async throws -> Bool {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            print("Biometry authentication failed: \(error?.localizedDescription ?? "Unknown")")
            throw AuthError.biometryUnavailable
        }

        let success = try await evaluateBiometry(context: context, reason: reason)
        if !success {
            throw AuthError.biometryFailed
        }
        return true
    }

    func availableBiometryType() -> BiometryType {
        let context = LAContext()
        _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)

        switch context.biometryType {
        case .faceID: return .faceID
        case .touchID: return .touchID
        default: return .none
        }
    }

    // MARK: - Private

    private func evaluateBiometry(context: LAContext, reason: String) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                if let error = error {
                    print("Biometry evaluatePolicy error: \(error.localizedDescription)")
                }
                continuation.resume(returning: success)
            }
        }
    }
}
