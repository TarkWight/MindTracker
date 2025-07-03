//
//  AuthServiceProtocol.swift
//  MindTracker
//
//  Created by Tark Wight on 03.07.2025.
//

import Foundation

protocol AuthServiceProtocol: Sendable {
    func logIn() async throws
    func isSessionActive() async -> Bool
    func tryAutoLogin() async throws -> Bool
    func setBiometryEnabled(_ enabled: Bool) async throws
    func isBiometryEnabled() async throws -> Bool
}
