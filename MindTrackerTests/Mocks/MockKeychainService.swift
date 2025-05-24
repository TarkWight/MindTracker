//
//  MockKeychainService.swift
//  MindTrackerTests
//
//  Created by Tark Wight on 24.05.2025.
//

import Foundation
@testable import MindTracker

actor MockKeychainService: KeychainServiceProtocol {
    private var boolStorage: [String: Bool] = [:]
    private var doubleStorage: [String: Double] = [:]

    func save(_ value: Bool, for key: String) async throws {
        boolStorage[key] = value
    }

    func save(_ value: Double, for key: String) async throws {
        doubleStorage[key] = value
    }

    func loadBool(for key: String) async throws -> Bool {
        return boolStorage[key] ?? false
    }

    func loadDouble(for key: String) async throws -> Double {
        return doubleStorage[key] ?? 0
    }
}
