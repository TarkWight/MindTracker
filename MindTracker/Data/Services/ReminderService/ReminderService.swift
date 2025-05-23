//
//  ReminderService.swift
//  MindTracker
//
//  Created by Tark Wight on 06.05.2025.
//

import Foundation
import CoreData

final class ReminderService: ReminderServiceProtocol, @unchecked Sendable {

    private let context: NSManagedObjectContext
    private let mapper: ReminderMapperProtocol
    private let reminderSchedulerService: ReminderSchedulerServiceProtocol

    init(
        context: NSManagedObjectContext,
        mapper: ReminderMapperProtocol,
        reminderSchedulerService: ReminderSchedulerServiceProtocol
    ) {
        self.context = context
        self.mapper = mapper
        self.reminderSchedulerService = reminderSchedulerService
    }

    private var storedReminders: [Reminder] = []

    func fetchReminders() async throws -> [Reminder] {
        try await context.perform {
            let request = ReminderEntity.typedFetchRequest
            let entities = try self.context.fetch(request)
            return entities.map { self.mapper.toDomain(from: $0)}
        }
    }

    func createReminder(_ reminder: Reminder) async throws {
        await context.perform {
            _ = self.mapper.toEntity(from: reminder, in: self.context)
        }
        try await contextSave()
        try await ReminderSchedulerService().schedule(id: reminder.id, time: reminder.time)
    }

    func updateReminder(_ reminder: Reminder) async throws {
        try await context.perform {
            let request = ReminderEntity.typedFetchRequest
            request.predicate = NSPredicate(format: "id == %@", reminder.id as CVarArg)
            guard let entity = try self.context.fetch(request).first else {
                throw NSError(domain: "Reminder not found", code: 404)
            }
            self.mapper.update(entity: entity, with: reminder, in: self.context)
        }
        try await contextSave()
        try await reminderSchedulerService.schedule(id: reminder.id, time: reminder.time)
    }

    func deleteReminder(by id: UUID) async throws {
        try await context.perform {
            let request = ReminderEntity.typedFetchRequest
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            let reminder = try self.context.fetch(request)
            reminder.forEach { self.context.delete($0) }
        }
        try await contextSave()
        try reminderSchedulerService.cancel(id: id)
    }

    private func contextSave() async throws {
        try await context.perform {
            if self.context.hasChanges {
                try self.context.save()
            }
        }
    }
}
