//
//  MockReminderSchedulerService.swift
//  MindTracker
//
//  Created by Tark Wight on 24.05.2025.
//

import Foundation

@testable import MindTracker

actor MockReminderSchedulerService: ReminderSchedulerServiceProtocol {
    private var scheduled: [UUID: Date] = [:]
    private var cancelled: [UUID] = []

    func schedule(id: UUID, time: Date) async throws {
        scheduled[id] = time
    }

    func cancel(id: UUID) throws {
        cancelled.append(id)
    }

    func scheduledTime(for id: UUID) async -> Date? {
        return scheduled[id]
    }

    func wasCancelled(_ id: UUID) async -> Bool {
        return cancelled.contains(id)
    }
}
