//
//  ReminderMapperProtocol.swift
//  MindTracker
//
//  Created by Tark Wight on 24.05.2025.
//

import CoreData
import Foundation

protocol ReminderMapperProtocol: Sendable {
    func toDomain(from entity: ReminderEntity) -> Reminder
    func toEntity(from model: Reminder, in context: NSManagedObjectContext)
        -> ReminderEntity
    func update(
        entity: ReminderEntity,
        with model: Reminder,
        in context: NSManagedObjectContext
    )
}
