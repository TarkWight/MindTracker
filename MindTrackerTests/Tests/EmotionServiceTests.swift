//
//  EmotionServiceTests.swift
//  MindTrackerTests
//
//  Created by Tark Wight on 24.05.2025.
//

import CoreData
import XCTest

@testable import MindTracker

final class EmotionServiceTests: XCTestCase {
    private var context: NSManagedObjectContext?
    private var service: EmotionServiceProtocol?
    private var mapper: EmotionMapperProtocol?

    override func setUpWithError() throws {
        try super.setUpWithError()

        let container = NSPersistentContainer(name: "AppStorage")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        var setupError: Error?
        let expectation = XCTestExpectation(
            description: "Persistent store loaded"
        )

        container.loadPersistentStores { _, error in
            if let error = error {
                setupError = error
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)

        if let error = setupError {
            throw error
        }

        let context = container.viewContext
        let mapper = MockEmotionMapper()
        let service = EmotionService(context: context, mapper: mapper)

        self.context = context
        self.mapper = mapper
        self.service = service
    }

    override func tearDownWithError() throws {
        context = nil
        service = nil
        mapper = nil
        try super.tearDownWithError()
    }

    func testSaveAndFetchEmotion() async throws {
        guard let service = service else {
            XCTFail("Service not initialized")
            return
        }
        let emotion = EmotionCard(
            id: UUID(),
            type: .anxiety,
            date: Date(),
            tags: EmotionTags(activity: [], people: [], location: [])
        )
        try await service.saveEmotion(emotion)

        let emotions = try await service.fetchEmotions()
        XCTAssertEqual(emotions.count, 1)
        XCTAssertEqual(emotions.first?.id, emotion.id)
    }

    func testContainsEmotion() async throws {
        guard let service = service else {
            XCTFail("Service not initialized")
            return
        }
        let id = UUID()
        let emotion = EmotionCard(
            id: id,
            type: .anxiety,
            date: Date(),
            tags: EmotionTags(activity: [], people: [], location: [])
        )
        try await service.saveEmotion(emotion)

        let result = try await service.containsEmotion(withId: id)
        XCTAssertTrue(result)

        let otherResult = try await service.containsEmotion(withId: UUID())
        XCTAssertFalse(otherResult)
    }

    func testUpdateEmotion() async throws {
        guard let service = service else {
            XCTFail("Service not initialized")
            return
        }
        let id = UUID()
        let emotion = EmotionCard(
            id: id,
            type: .anxiety,
            date: Date(),
            tags: EmotionTags(activity: [], people: [], location: [])
        )
        try await service.saveEmotion(emotion)

        let updated = EmotionCard(
            id: id,
            type: .apathy,
            date: Date(),
            tags: EmotionTags(activity: [], people: [], location: [])
        )
        try await service.updateEmotion(updated)

        let emotions = try await service.fetchEmotions()
        XCTAssertEqual(emotions.first?.type, .apathy)
    }

    func testDeleteEmotion() async throws {
        guard let service = service else {
            XCTFail("Service not initialized")
            return
        }
        let id = UUID()
        let emotion = EmotionCard(
            id: id,
            type: .anxiety,
            date: Date(),
            tags: EmotionTags(activity: [], people: [], location: [])
        )
        try await service.saveEmotion(emotion)

        try await service.deleteEmotion(by: id)
        let emotions = try await service.fetchEmotions()
        XCTAssertTrue(emotions.isEmpty)
    }

    func testDeleteAllEmotions() async throws {
        guard let service = service else {
            XCTFail("Service not initialized")
            return
        }
        try await service.saveEmotion(
            EmotionCard(
                id: UUID(),
                type: .anxiety,
                date: Date(),
                tags: EmotionTags(activity: [], people: [], location: [])
            )
        )
        try await service.saveEmotion(
            EmotionCard(
                id: UUID(),
                type: .calmness,
                date: Date(),
                tags: EmotionTags(activity: [], people: [], location: [])
            )
        )

        guard let context = context else {
            XCTFail("Context not initialized")
            return
        }
        try await context.perform {
            let fetchRequest = EmotionEntity.typedFetchRequest
            let allEmotions = try context.fetch(fetchRequest)
            allEmotions.forEach { context.delete($0) }
        }

        let emotions = try await service.fetchEmotions()
        XCTAssertTrue(emotions.isEmpty)
    }
}
