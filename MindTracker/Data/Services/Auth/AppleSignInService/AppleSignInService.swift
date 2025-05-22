//
//  AppleSignInService.swift
//  MindTracker
//
//  Created by Tark Wight on 22.05.2025.
//

import Foundation

actor AppleSignInService: AppleSignInServiceProtocol {

    private let keychainService: KeychainServiceProtocol

    init(keychainService: KeychainServiceProtocol) {
        self.keychainService = keychainService
    }

    func signIn() async throws -> AppleSignInCredential {
        let credential = AppleSignInCredential(
            user: UUID().uuidString,
            fullName: PersonNameComponentsFormatter().personNameComponents(from: "Mock User"),
            email: "mock@example.com",
            isLikelyReal: true
        )

        try await keychainService.save(Date().timeIntervalSince1970, for: KeychainKeys.appleSignInTimestamp)
        return credential
    }

    func isSessionActive() async -> Bool {
        do {
            let timestamp = try await keychainService.loadDouble(for: KeychainKeys.appleSignInTimestamp)
            let last = Date(timeIntervalSince1970: timestamp)
            return Date().timeIntervalSince(last) < 15
        } catch {
            return false
        }
    }
}
