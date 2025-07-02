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
        if enabled {
            let success = try await authenticate(reason: "Включить биометрию для входа")
            if success {
                try await keychain.save(true, for: key)
            } else {
                throw AuthError.biometryFailed
            }
        } else {
            try await keychain.save(false, for: key)
        }
    }

    func authenticate(reason: String) async throws -> Bool {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            throw AuthError.biometryUnavailable
        }

        return try await withCheckedThrowingContinuation { continuation in
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
                continuation.resume(returning: success)
            }
        }
    }

    func availableBiometryType() -> BiometryType {
        let context = LAContext()
        _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)

        switch context.biometryType {
        case .faceID:
            return .faceID
        case .touchID:
            return .touchID
        default:
            return .none
        }
    }
}
