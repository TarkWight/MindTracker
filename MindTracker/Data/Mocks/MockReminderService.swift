//
//  MockReminderService.swift
//  MindTracker
//
//  Created by Tark Wight on 06.05.2025.
//

import Foundation

actor MockReminderService: ReminderServiceProtocol {

    private var storedReminders: [ReminderDTO] = []

    // MARK: - Load

    func loadReminders() async throws -> [Reminder] {
        return storedReminders.map(ReminderMapper.map(from:))
    }

    // MARK: - Save (full replace)

    func saveReminders(_ reminders: [Reminder]) async throws {
        storedReminders = reminders.map(ReminderMapper.map(from:))
    }

    // MARK: - Update

    func updateReminder(_ reminder: Reminder) async throws {
        guard let index = storedReminders.firstIndex(where: { $0.id == reminder.id }) else {
            throw ReminderServiceError.reminderNotFound
        }

        storedReminders[index] = ReminderMapper.map(from: reminder)
    }

    // MARK: - Delete

    func deleteReminder(_ reminder: Reminder) async throws {
        guard let index = storedReminders.firstIndex(where: { $0.id == reminder.id }) else {
            throw ReminderServiceError.reminderNotFound
        }

        storedReminders.remove(at: index)
    }
}
