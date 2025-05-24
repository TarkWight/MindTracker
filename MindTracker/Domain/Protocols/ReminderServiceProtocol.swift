//
//  ReminderServiceProtocol.swift
//  MindTracker
//
//  Created by Tark Wight on 06.05.2025.
//

import Foundation

protocol ReminderServiceProtocol: Sendable {
    func fetchReminders() async throws -> [Reminder]
    func createReminder(_ reminder: Reminder) async throws
    func updateReminder(_ reminder: Reminder) async throws
    func deleteReminder(by id: UUID) async throws
}
