//
//  AppleSignInServiceTests.swift
//  MindTracker
//
//  Created by Tark Wight on 24.05.2025.
//

import XCTest
@testable import MindTracker

final class AppleSignInServiceTests: XCTestCase {
    private var service: AppleSignInService!
    private var mockKeychain: MockKeychainService!

    override func setUp() {
        super.setUp()
        mockKeychain = MockKeychainService()
        service = AppleSignInService(keychainService: mockKeychain)
    }

    func testSignInStoresTimestamp() async throws {
        let credential = try await service.signIn()
        XCTAssertNotNil(UUID(uuidString: credential.user))
        XCTAssertEqual(credential.email, "mock@example.com")
        XCTAssertTrue(credential.isLikelyReal)

        let timestamp = try await mockKeychain.loadDouble(for: KeychainKeys.appleSignInTimestamp)
        XCTAssertGreaterThan(timestamp, 0)
    }

    func testIsSessionActiveTrue() async throws {
        try await mockKeychain.save( Date().timeIntervalSince1970, for: KeychainKeys.appleSignInTimestamp)
        let isActive = await service.isSessionActive()
        XCTAssertTrue(isActive)
    }

    func testIsSessionActiveFalseDueToOldDate() async throws {
        try await mockKeychain.save( Date().addingTimeInterval(-60).timeIntervalSince1970, for: KeychainKeys.appleSignInTimestamp)
        let isActive = await service.isSessionActive()
        XCTAssertFalse(isActive)
    }

    func testIsSessionActiveFalseDueToError() async {
        await mockKeychain.setShouldThrow(true)
        let isActive = await service.isSessionActive()
        XCTAssertFalse(isActive)
    }
}
