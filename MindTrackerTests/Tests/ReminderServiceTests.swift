//
//  ReminderServiceTests.swift
//  MindTrackerTests
//
//  Created by Tark Wight on 24.05.2025.
//

import XCTest
import CoreData
@testable import MindTracker

final class ReminderServiceTests: XCTestCase {
    private var context: NSManagedObjectContext?
    private var service: ReminderServiceProtocol?
    private var mapper: ReminderMapperProtocol?
    private var scheduler: MockReminderSchedulerService?

    override func setUpWithError() throws {
        try super.setUpWithError()

        let container = NSPersistentContainer(name: "AppStorage")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        let expectation = XCTestExpectation(description: "Persistent store loaded")
        var setupError: Error?

        container.loadPersistentStores { _, error in
            setupError = error
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
        if let error = setupError {
            throw error
        }

        let context = container.viewContext
        let mapper = MockReminderMapper()
        let scheduler = MockReminderSchedulerService()
        let service = ReminderService(context: context, mapper: mapper, reminderSchedulerService: scheduler)

        self.context = context
        self.mapper = mapper
        self.scheduler = scheduler
        self.service = service
    }

    override func tearDownWithError() throws {
        context = nil
        service = nil
        mapper = nil
        scheduler = nil
        try super.tearDownWithError()
    }

    func testCreateReminderStoresAndSchedules() async throws {
        guard let service = service,
              let scheduler = scheduler,
              let context = context else {
            XCTFail("Dependencies not initialized")
            return
        }

        let reminder = Reminder(id: UUID(), time: Date().addingTimeInterval(60))
        try await service.createReminder(reminder)

        try await context.perform {
            try context.save()
        }

        let scheduled = await scheduler.scheduledTime(for: reminder.id)
        if let scheduledTime = scheduled?.timeIntervalSince1970 {
            XCTAssertEqual(scheduledTime, reminder.time.timeIntervalSince1970, accuracy: 0.1, "Reminder should be scheduled with correct time")
        } else {
            XCTFail("Scheduled time is nil", file: #file, line: #line)
        }
    }

    func testUpdateReminderUpdatesAndReschedules() async throws {
        guard let service = service,
              let scheduler = scheduler else {
            XCTFail("Dependencies not initialized")
            return
        }

        let id = UUID()
        let initial = Reminder(id: id, time: Date().addingTimeInterval(60))
        try await service.createReminder(initial)

        let updated = Reminder(id: id, time: Date().addingTimeInterval(120))
        try await service.updateReminder(updated)

        let scheduled = await scheduler.scheduledTime(for: id)
        XCTAssertEqual(scheduled, updated.time, "Reminder should be rescheduled with updated time")
    }

    func testDeleteReminderRemovesAndCancels() async throws {
        guard let service = service,
              let scheduler = scheduler else {
            XCTFail("Dependencies not initialized")
            return
        }

        let id = UUID()
        let reminder = Reminder(id: id, time: Date().addingTimeInterval(60))
        try await service.createReminder(reminder)

        try await service.deleteReminder(by: id)

        let wasCancelled = await scheduler.wasCancelled(id)
        XCTAssertTrue(wasCancelled, "Reminder should be cancelled upon deletion")
    }
}
