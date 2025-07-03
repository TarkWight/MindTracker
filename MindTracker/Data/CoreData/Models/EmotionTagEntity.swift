//
//  EmotionTagEntity.swift
//  MindTracker
//
//  Created by Tark Wight on 25.04.2025.
//

import CoreData
import Foundation

@objc(EmotionTagEntity)
final class EmotionTagEntity: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var tagTypeRaw: String

    @NSManaged var emotionActivity: EmotionEntity?
    @NSManaged var emotionPeople: EmotionEntity?
    @NSManaged var emotionLocation: EmotionEntity?
}

extension EmotionTagEntity {
    static var typedFetchRequest: NSFetchRequest<EmotionTagEntity> {
        NSFetchRequest<EmotionTagEntity>(entityName: "EmotionTagEntity")
    }
}
