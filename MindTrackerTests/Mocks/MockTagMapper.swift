//
//  MockTagMapper.swift
//  MindTracker
//
//  Created by Tark Wight on 24.05.2025.
//

import CoreData
import Foundation

@testable import MindTracker

final actor MockTagMapper: @preconcurrency TagMapperProtocol {
    private(set) var toDomainCalled = false
    private(set) var toEntityCalled = false

    func toDomain(from entity: EmotionTagEntity) -> EmotionTag {
        toDomainCalled = true
        return EmotionTag(
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
        toEntityCalled = true

        guard
            let description = NSEntityDescription.entity(
                forEntityName: "EmotionTagEntity",
                in: context
            )
        else {
            fatalError("Could not find entity description for EmotionTagEntity")
        }

        let entity = EmotionTagEntity(entity: description, insertInto: context)
        entity.id = model.id
        entity.name = model.name
        entity.tagTypeRaw = type.rawValue
        return entity
    }
}
