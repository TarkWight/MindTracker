//
//  ReminderSchedulerServiceTests.swift
//  MindTrackerTests
//
//  Created by Tark Wight on 24.05.2025.
//

import UserNotifications
import XCTest

@testable import MindTracker

final class ReminderSchedulerServiceTests: XCTestCase {
    private var notificationCenter: UNUserNotificationCenter?
    private var service: ReminderSchedulerServiceProtocol?

    override func setUpWithError() throws {
        try super.setUpWithError()
        notificationCenter = UNUserNotificationCenter.current()
        service = ReminderSchedulerService()
    }

    override func tearDownWithError() throws {
        notificationCenter = nil
        service = nil
        try super.tearDownWithError()
    }

    func testScheduleReminderDoesNotThrow() async throws {
        guard let service = service else {
            XCTFail("Service not initialized")
            return
        }

        let id = UUID()
        let time =
            Calendar.current.date(byAdding: .minute, value: 1, to: Date())
            ?? Date()

        do {
            try await service.schedule(id: id, time: time)
        } catch {
            XCTFail("Scheduling should not throw, but threw: \(error)")
        }
    }

    func testCancelReminderDoesNotThrow() async {
        guard let service = service else {
            XCTFail("Service not initialized")
            return
        }

        let id = UUID()

        do {
            try await service.cancel(id: id)
        } catch {
            XCTFail("Cancel should not throw, but threw: \(error)")
        }
    }
}
