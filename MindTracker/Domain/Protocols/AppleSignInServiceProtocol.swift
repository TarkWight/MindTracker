//
//  AppleSignInServiceProtocol.swift
//  MindTracker
//
//  Created by Tark Wight on 22.05.2025.
//

import Foundation

protocol AppleSignInServiceProtocol: Sendable {
    func signIn() async throws -> AppleSignInCredential
    func isSessionActive() async -> Bool
}
