//
//  ReminderMapper.swift
//  MindTracker
//
//  Created by Tark Wight on 06.05.2025.
//

import Foundation
import CoreData

final class ReminderMapper: ReminderMapperProtocol {
    func toDomain(from entity: ReminderEntity) -> Reminder {
        Reminder(
            id: entity.id,
            time: entity.time
        )
    }

    func toEntity(from model: Reminder, in context: NSManagedObjectContext) -> ReminderEntity {
        let entity = ReminderEntity(context: context)
        entity.id = model.id
        entity.time = model.time
        return entity
    }

    func update(entity: ReminderEntity, with model: Reminder, in context: NSManagedObjectContext) {
        entity.id = model.id
        entity.time = model.time
    }
}
