//
//  MockReminderMapper.swift
//  MindTracker
//
//  Created by Tark Wight on 24.05.2025.
//

import Foundation
import CoreData
@testable import MindTracker

final actor MockReminderMapper: @preconcurrency ReminderMapperProtocol {
    var toEntityCalled = false
    var toDomainCalled = false
    var updateCalled = false

    func toEntity(from model: Reminder, in context: NSManagedObjectContext) -> ReminderEntity {
        toEntityCalled = true
        guard let description = NSEntityDescription.entity(forEntityName: "ReminderEntity", in: context) else {
            fatalError("⚠️ Could not find entity description for ReminderEntity")
        }
        let entity = ReminderEntity(entity: description, insertInto: context)
        entity.id = model.id
        entity.time = model.time
        return entity
    }

    func toDomain(from entity: ReminderEntity) -> Reminder {
        toDomainCalled = true
        return Reminder(
            id: entity.id,
            time: entity.time
        )
    }

    func update(entity: ReminderEntity, with model: Reminder, in context: NSManagedObjectContext) {
        updateCalled = true
        entity.time = model.time
    }
}
