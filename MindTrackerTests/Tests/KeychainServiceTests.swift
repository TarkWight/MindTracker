//
//  KeychainServiceTests.swift
//  MindTrackerTests
//
//  Created by Tark Wight on 24.05.2025.
//

import XCTest

@testable import MindTracker

final class KeychainServiceTests: XCTestCase {
    private var keychain: MockKeychainService!

    override func setUp() {
        super.setUp()
        keychain = MockKeychainService()
    }

    func testSaveAndLoadBool() async throws {
        let key = "test.bool.key"
        try await keychain.save(true, for: key)
        let loaded = try await keychain.loadBool(for: key)
        XCTAssertTrue(loaded)

        try await keychain.save(false, for: key)
        let loadedFalse = try await keychain.loadBool(for: key)
        XCTAssertFalse(loadedFalse)
    }

    func testSaveAndLoadDouble() async throws {
        let key = "test.double.key"
        let value: Double = 42.42
        try await keychain.save(value, for: key)
        let loaded = try await keychain.loadDouble(for: key)
        XCTAssertEqual(loaded, value, accuracy: 0.0001)
    }

    func testLoadBoolDefaultFalse() async throws {
        let loaded = try await keychain.loadBool(for: "missing.key")
        XCTAssertFalse(loaded)
    }

    func testLoadDoubleDefaultZero() async throws {
        let loaded = try await keychain.loadDouble(for: "missing.key")
        XCTAssertEqual(loaded, 0)
    }
}
