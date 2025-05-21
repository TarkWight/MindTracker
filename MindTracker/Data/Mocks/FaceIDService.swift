//
//  FaceIDService.swift
//  MindTracker
//
//  Created by Tark Wight on 06.05.2025.
//

import Foundation
import AuthenticationServices
import Security

enum KeychainKeys {
    static let faceIDEnabled = "com.mindtracker.faceid.enabled"
}

actor FaceIDService: FaceIDServiceProtocol, AppleSignInServiceProtocol {
    private var isEnabledCache: Bool?

    func isFaceIDEnabled() async throws -> Bool {
        if let cached = isEnabledCache {
            return cached
        } else {
            let loaded = loadFaceIDEnabled()
            isEnabledCache = loaded
            return loaded
        }
    }

    func setFaceIDEnabled(_ enabled: Bool) async throws {
        isEnabledCache = enabled
        saveFaceIDEnabled(enabled)
    }

    private func saveFaceIDEnabled(_ enabled: Bool) {
        let data = Data([enabled ? 1 : 0])
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: KeychainKeys.faceIDEnabled,
            kSecValueData as String: data
        ]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    private func loadFaceIDEnabled() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: KeychainKeys.faceIDEnabled,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        if SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess,
           let data = result as? Data,
           let byte = data.first {
            return byte == 1
        }
        return false
    }

    func signIn() async throws -> AppleSignInCredential {
        try await Task.sleep(nanoseconds: 4_000_000_000)

        return AppleSignInCredential(
            user: UUID().uuidString,
            fullName: PersonNameComponentsFormatter().personNameComponents(from: "Mock User"),
            email: "mock@example.com",
            isLikelyReal: true
        )
    }
}
