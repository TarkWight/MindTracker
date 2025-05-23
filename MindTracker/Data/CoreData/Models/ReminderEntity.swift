//
//  ReminderEntity.swift
//  MindTracker
//
//  Created by Tark Wight on 24.05.2025.
//

import Foundation
import CoreData

@objc(ReminderEntity)
final class ReminderEntity: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var time: Date
}

extension ReminderEntity {
    static var typedFetchRequest: NSFetchRequest<ReminderEntity> {
        NSFetchRequest<ReminderEntity>(entityName: "ReminderEntity")
    }
}
