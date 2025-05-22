//
//  AppleSignInService.swift
//  MindTracker
//
//  Created by Tark Wight on 22.05.2025.
//

import Foundation

actor AppleSignInService: AppleSignInServiceProtocol {
    
    private var lastSignInDate: Date?

    func signIn() async throws -> AppleSignInCredential {
        try await Task.sleep(nanoseconds: 4_000_000_000)
        
        let credential = AppleSignInCredential(
            user: UUID().uuidString,
            fullName: PersonNameComponentsFormatter().personNameComponents(from: "Mock User"),
            email: "mock@example.com",
            isLikelyReal: true
        )
        
        lastSignInDate = Date()
        return credential
    }
    
    func isSessionActive() async -> Bool {
        guard let last = lastSignInDate else { return false }
        return Date().timeIntervalSince(last) < 1800 // 30 минут
    }
}
