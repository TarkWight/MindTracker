//
//  EmotionEntity.swift
//  MindTracker
//
//  Created by Tark Wight on 25.04.2025.
//

import CoreData
import Foundation

@objc(EmotionEntity)
final class EmotionEntity: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var typeRaw: String
    @NSManaged var timestamp: Date
    @NSManaged var tagsActivity: Set<EmotionTagEntity>?
    @NSManaged var tagsPeople: Set<EmotionTagEntity>?
    @NSManaged var tagsLocation: Set<EmotionTagEntity>?
}

extension EmotionEntity {
    static var typedFetchRequest: NSFetchRequest<EmotionEntity> {
        NSFetchRequest<EmotionEntity>(entityName: "EmotionEntity")
    }
}
