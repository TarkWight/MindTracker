//
//  MockAppleSignInService.swift
//  MindTracker
//
//  Created by Tark Wight on 24.05.2025.
//

import Foundation

@testable import MindTracker

final actor MockAppleSignInService: AppleSignInServiceProtocol {
    var shouldThrow = false
    var signInCalled = false
    var mockTimestamp: Double? = nil

    func signIn() async throws -> AppleSignInCredential {
        signInCalled = true
        if shouldThrow {
            throw NSError(domain: "SignIn", code: 1)
        }
        return AppleSignInCredential(
            user: UUID().uuidString,
            fullName: nil,
            email: "mock@example.com",
            isLikelyReal: true
        )
    }

    func isSessionActive() async -> Bool {
        guard let time = mockTimestamp else { return false }
        return Date().timeIntervalSince1970 - time < 15
    }
}
