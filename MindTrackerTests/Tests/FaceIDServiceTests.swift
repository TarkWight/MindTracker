//
//  FaceIDServiceTests.swift
//  MindTracker
//
//  Created by Tark Wight on 24.05.2025.
//

import XCTest

@testable import MindTracker

final class FaceIDServiceTests: XCTestCase {
    private var service: FaceIDService?
    private var mockKeychain: MockKeychainService?

    override func setUp() {
        super.setUp()
        let mockKeychain = MockKeychainService()
        self.mockKeychain = mockKeychain
        self.service = FaceIDService(keychainService: mockKeychain)
    }

    func testIsFaceIDEnabledReturnsCachedValue() async throws {
        guard let service = service, let mockKeychain = mockKeychain else {
            XCTFail("Dependencies not initialized")
            return
        }

        try await service.setFaceIDEnabled(true)
        let result = try await service.isFaceIDEnabled()
        XCTAssertTrue(result)

        await mockKeychain.setShouldThrow(true)  // должен вернуться кэш
        let cached = try await service.isFaceIDEnabled()
        XCTAssertTrue(cached)
    }

    func testIsFaceIDEnabledFetchesFromKeychain() async throws {
        guard let service = service, let mockKeychain = mockKeychain else {
            XCTFail("Dependencies not initialized")
            return
        }

        try await mockKeychain.save(true, for: KeychainKeys.biometryEnabled)
        let result = try await service.isFaceIDEnabled()
        XCTAssertTrue(result)
    }

    func testSetFaceIDEnabledStoresToKeychain() async throws {
        guard let service = service, let mockKeychain = mockKeychain else {
            XCTFail("Dependencies not initialized")
            return
        }

        try await service.setFaceIDEnabled(false)
        let stored = try await mockKeychain.loadBool(
            for: KeychainKeys.biometryEnabled
        )
        XCTAssertFalse(stored)
    }

    func testIsFaceIDEnabledThrowsOnKeychainError() async {
        guard let service = service, let mockKeychain = mockKeychain else {
            XCTFail("Dependencies not initialized")
            return
        }

        await mockKeychain.setShouldThrow(true)
        do {
            _ = try await service.isFaceIDEnabled()
            XCTFail("Expected error was not thrown")
        } catch {
            // Success: expected error was caught
        }
    }
}
