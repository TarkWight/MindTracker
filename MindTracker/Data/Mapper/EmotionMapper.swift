//
//  EmotionMapper.swift
//  MindTracker
//
//  Created by Tark Wight on 25.04.2025.
//

import Foundation
import CoreData

final class EmotionMapper: EmotionMapperProtocol {

    func toDomain(from entity: EmotionEntity) -> EmotionCard {
        EmotionCard(
            id: entity.id,
            type: EmotionType(rawValue: entity.typeRaw) ?? .placeholder,
            date: entity.timestamp,
            tags: EmotionTags(
                activity: mapTags(from: entity.tagsActivity, type: .activity),
                people: mapTags(from: entity.tagsPeople, type: .people),
                location: mapTags(from: entity.tagsLocation, type: .location)
            )
        )
    }

    func toEntity(from model: EmotionCard, in context: NSManagedObjectContext) -> EmotionEntity {
        let entity = EmotionEntity(context: context)
        entity.id = model.id
        entity.typeRaw = model.type.rawValue
        entity.timestamp = model.date
        entity.tagsActivity = makeTagEntities(from: model.tags.activity, type: .activity, attachedTo: entity, context: context)
        entity.tagsPeople = makeTagEntities(from: model.tags.people, type: .people, attachedTo: entity, context: context)
        entity.tagsLocation = makeTagEntities(from: model.tags.location, type: .location, attachedTo: entity, context: context)
        return entity
    }

    func update(entity: EmotionEntity, with model: EmotionCard, in context: NSManagedObjectContext) {
        entity.id = model.id
        entity.typeRaw = model.type.rawValue
        entity.timestamp = model.date

        entity.tagsActivity?.forEach { context.delete($0) }
        entity.tagsPeople?.forEach { context.delete($0) }
        entity.tagsLocation?.forEach { context.delete($0) }

        entity.tagsActivity = makeTagEntities(from: model.tags.activity, type: .activity, attachedTo: entity, context: context)
        entity.tagsPeople = makeTagEntities(from: model.tags.people, type: .people, attachedTo: entity, context: context)
        entity.tagsLocation = makeTagEntities(from: model.tags.location, type: .location, attachedTo: entity, context: context)
    }

    private func mapTags(from set: Set<EmotionTagEntity>?, type: TagType) -> [EmotionTag] {
        guard let set else { return [] }
        return set.map {
            EmotionTag(id: $0.id, name: $0.name, tagTypeRaw: type.rawValue)
        }
    }

    private func makeTagEntities(
        from tags: [EmotionTag],
        type: TagType,
        attachedTo emotion: EmotionEntity,
        context: NSManagedObjectContext
    ) -> Set<EmotionTagEntity> {
        Set(tags.map {
            fetchOrCreateTagEntity(name: $0.name, type: type, attachedTo: emotion, context: context)
        })
    }

    private func fetchOrCreateTagEntity(
        name: String,
        type: TagType,
        attachedTo emotion: EmotionEntity,
        context: NSManagedObjectContext
    ) -> EmotionTagEntity {
        let request: NSFetchRequest<EmotionTagEntity> = EmotionTagEntity.typedFetchRequest
        request.predicate = NSPredicate(format: "name == %@ AND tagTypeRaw == %@", name, type.rawValue)
        request.fetchLimit = 1

        if let existing = try? context.fetch(request).first {
            switch type {
            case .activity: existing.emotionActivity = emotion
            case .people:   existing.emotionPeople = emotion
            case .location: existing.emotionLocation = emotion
            }
            return existing
        }

        let newTag = EmotionTagEntity(context: context)
        newTag.id = UUID()
        newTag.name = name
        newTag.tagTypeRaw = type.rawValue

        switch type {
        case .activity: newTag.emotionActivity = emotion
        case .people:   newTag.emotionPeople = emotion
        case .location: newTag.emotionLocation = emotion
        }

        return newTag
    }

    private func createTagEntity(
        _ tag: EmotionTag,
        type: TagType,
        attachedTo emotion: EmotionEntity,
        context: NSManagedObjectContext
    ) -> EmotionTagEntity {
        let entity = EmotionTagEntity(context: context)
        entity.id = tag.id
        entity.name = tag.name
        entity.tagTypeRaw = type.rawValue

        switch type {
        case .activity:
            entity.emotionActivity = emotion
        case .people:
            entity.emotionPeople = emotion
        case .location:
            entity.emotionLocation = emotion
        }

        return entity
    }
}
