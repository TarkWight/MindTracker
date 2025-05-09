//
//  ReminderServiceProtocol.swift
//  MindTracker
//
//  Created by Tark Wight on 06.05.2025.
//

import Foundation

protocol ReminderServiceProtocol: Sendable {
    func loadReminders() async throws -> [Reminder]
    func saveReminders(_ reminders: [Reminder]) async throws
    func updateReminder(_ reminder: Reminder) async throws
    func deleteReminder(_ reminder: Reminder) async throws
}
