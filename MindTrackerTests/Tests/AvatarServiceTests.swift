//
//  AvatarServiceTests.swift
//  MindTrackerTests
//
//  Created by Tark Wight on 24.05.2025.
//

import XCTest
@testable import MindTracker

final class AvatarServiceTests: XCTestCase {
    private var service: AvatarServiceProtocol?
    private var testAvatarData: Data?

    override func setUpWithError() throws {
        try super.setUpWithError()
        service = AvatarService()
        testAvatarData = Data("TestAvatar".utf8)
    }

    override func tearDown() async throws {
        if let service = service {
            try await service.deleteAvatar()
        } else {
            XCTFail("Service is nil in tearDown")
        }
        service = nil
        testAvatarData = nil
        try await super.tearDown()
    }

    func testSaveAndLoadAvatar() async throws {
        guard let service = service else {
            XCTFail("Service is nil")
            return
        }
        guard let data = testAvatarData else {
            XCTFail("Test avatar data is nil")
            return
        }

        let avatar = Avatar(data: data)
        try await service.saveAvatar(avatar)

        let loaded = try await service.loadAvatar()
        XCTAssertEqual(loaded, data, "Loaded avatar data should match saved data.")
    }

    func testDeleteAvatar() async throws {
        guard let service = service else {
            XCTFail("Service is nil")
            return
        }
        guard let data = testAvatarData else {
            XCTFail("Test avatar data is nil")
            return
        }

        let avatar = Avatar(data: data)
        try await service.saveAvatar(avatar)
        try await service.deleteAvatar()

        let loaded = try await service.loadAvatar()
        XCTAssertNil(loaded, "Deleted avatar should return nil on load.")
    }

    func testUpdateAvatar() async throws {
        guard let data = testAvatarData else {
            XCTFail("Test avatar data is nil")
            return
        }
        let oldData = Data("Old".utf8)

        let initialAvatar = Avatar(data: oldData)
        try await service?.saveAvatar(initialAvatar)

        let updatedAvatar = Avatar(data: data)
        try await service?.updateAvatar(updatedAvatar)

        let loaded = try await service?.loadAvatar()
        XCTAssertEqual(loaded, data, "Updated avatar should be returned on load.")
    }

    func testSaveAvatarWithInvalidDataThrows() async {
        guard let service = service else {
            XCTFail("Service is nil")
            return
        }
        let avatar = Avatar(data: nil)

        do {
            try await service.saveAvatar(avatar)
            XCTFail("Expected error when saving avatar with nil data.")
        } catch AvatarService.AvatarServiceError.invalidData {
            // Success
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
}
