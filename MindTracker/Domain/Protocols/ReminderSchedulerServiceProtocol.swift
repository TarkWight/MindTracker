//
//  ReminderSchedulerServiceProtocol.swift
//  MindTracker
//
//  Created by Tark Wight on 24.05.2025.
//


import Foundation

protocol ReminderSchedulerServiceProtocol: Sendable {
    func schedule(id: UUID, time: Date) async throws
    func cancel(id: UUID) throws
}
