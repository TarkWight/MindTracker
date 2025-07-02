//
//  TagMapper.swift
//  MindTracker
//
//  Created by Tark Wight on 24.05.2025.
//

import CoreData
import Foundation

final class TagMapper: TagMapperProtocol {
    func toDomain(from entity: EmotionTagEntity) -> EmotionTag {
        EmotionTag(
            id: entity.id,
            name: entity.name,
            tagTypeRaw: entity.tagTypeRaw
        )
    }

    func toEntity(
        from model: EmotionTag,
        type: TagType,
        context: NSManagedObjectContext
    ) -> EmotionTagEntity {
        let entity = EmotionTagEntity(context: context)
        entity.id = model.id
        entity.name = model.name
        entity.tagTypeRaw = type.rawValue
        return entity
    }
}
