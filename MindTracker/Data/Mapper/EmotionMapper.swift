//
//  EmotionMapper.swift
//  MindTracker
//
//  Created by Tark Wight on 25.04.2025.
//

import Foundation
import CoreData

final class EmotionMapper: EmotionMapperProtocol {

    // MARK: - To Domain

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

    private func mapTags(from set: Set<EmotionTagEntity>?, type: TagType) -> [EmotionTag] {
        guard let set else { return [] }
        return set.map {
            EmotionTag(id: $0.id, name: $0.name, tagTypeRaw: type.rawValue)
        }
    }

    // MARK: - To Entity

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

    // MARK: - Update

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

    // MARK: - From DTO

    func fromDTO(_ dto: EmotionDTO) -> EmotionCard {
        EmotionCard(
            id: dto.id,
            type: EmotionType(rawValue: dto.typeRaw) ?? .placeholder,
            date: Date(timeIntervalSince1970: dto.timestamp),
            tags: EmotionTags(
                activity: dto.activityTagNames.map { EmotionTag(id: UUID(), name: $0, tagTypeRaw: TagType.activity.rawValue) },
                people: dto.peopleTagNames.map { EmotionTag(id: UUID(), name: $0, tagTypeRaw: TagType.people.rawValue) },
                location: dto.locationTagNames.map { EmotionTag(id: UUID(), name: $0, tagTypeRaw: TagType.location.rawValue) }
            )
        )
    }

    // MARK: - To DTO

    func toDTO(from model: EmotionCard) -> EmotionDTO {
        EmotionDTO(
            id: model.id,
            typeRaw: model.type.rawValue,
            timestamp: model.date.timeIntervalSince1970,
            activityTagNames: model.tags.activity.map { $0.name },
            peopleTagNames: model.tags.people.map { $0.name },
            locationTagNames: model.tags.location.map { $0.name }
        )
    }

    // MARK: - Private Tag Helpers

    private func makeTagEntities(
        from tags: [EmotionTag],
        type: TagType,
        attachedTo emotion: EmotionEntity,
        context: NSManagedObjectContext
    ) -> Set<EmotionTagEntity> {
        Set(tags.map { createTagEntity($0, type: type, attachedTo: emotion, context: context) })
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
