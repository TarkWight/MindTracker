//
//  KeychainKeysProtocol.swift
//  MindTracker
//
//  Created by Tark Wight on 22.05.2025.
//

import Foundation

protocol KeychainServiceProtocol: Sendable {
    func save(_ value: Bool, for key: String) async throws
    func save(_ value: Double, for key: String) async throws
    func loadBool(for key: String) async throws -> Bool
    func loadDouble(for key: String) async throws -> Double
}
