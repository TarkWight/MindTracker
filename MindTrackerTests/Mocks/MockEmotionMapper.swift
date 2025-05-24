//
//  MockEmotionMapper.swift
//  MindTracker
//
//  Created by Tark Wight on 24.05.2025.
//

import Foundation
@testable import MindTracker
import CoreData

final actor MockEmotionMapper: @preconcurrency EmotionMapperProtocol {
    var toEntityCalled = false
    var updateCalled = false
    var toDomainCalled = false

    func toDomain(from entity: EmotionEntity) -> EmotionCard {
        toDomainCalled = true
        return EmotionCard(
            id: entity.id,
            type: EmotionType(rawValue: entity.typeRaw) ?? .placeholder,
            date: entity.timestamp,
            tags: EmotionTags(activity: [], people: [], location: [])
        )
    }

    func toEntity(from model: EmotionCard, in context: NSManagedObjectContext) -> EmotionEntity {
        toEntityCalled = true
        guard let description = NSEntityDescription.entity(forEntityName: "EmotionEntity", in: context) else {
            fatalError("Could not find entity description for EmotionEntity")
        }
        let entity = EmotionEntity(entity: description, insertInto: context)
        entity.id = model.id
        entity.typeRaw = model.type.rawValue
        entity.timestamp = model.date
        return entity
    }

    func update(entity: EmotionEntity, with model: EmotionCard, in context: NSManagedObjectContext) {
        updateCalled = true
        entity.id = model.id
        entity.typeRaw = model.type.rawValue
        entity.timestamp = model.date
    }
}
