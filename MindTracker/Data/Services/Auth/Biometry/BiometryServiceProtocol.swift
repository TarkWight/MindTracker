//
//  BiometryServiceProtocol.swift
//  MindTracker
//
//  Created by Tark Wight on 03.07.2025.
//

import LocalAuthentication

protocol BiometryServiceProtocol: Sendable {
    func isBiometryEnabled() async throws -> Bool
    func setBiometryEnabled(_ enabled: Bool) async throws
    func authenticate(reason: String) async throws -> Bool
    func availableBiometryType() -> BiometryType
}
