//
//  EmotionMapper.swift
//  MindTracker
//
//  Created by Tark Wight on 25.04.2025.
//

import Foundation
import CoreData

// MARK: - EmotionMapper

final class EmotionMapper: EmotionMapperProtocol {

    // MARK: - To Domain

    func toDomain(from entity: EmotionEntity) -> EmotionCard {
        EmotionCard(
            id: entity.id,
            type: EmotionType(rawValue: entity.typeRaw) ?? .placeholder,
            date: entity.timestamp,
            tags: EmotionTags(
                activity: mapTags(from: entity.tagsActivity),
                people: mapTags(from: entity.tagsPeople),
                location: mapTags(from: entity.tagsLocation)
            )
        )
    }

    private func mapTags(from set: Set<EmotionTagEntity>?) -> [EmotionTag] {
        guard let set else { return [] }
        return set.map { EmotionTag(id: $0.id, name: $0.name) }
    }

    // MARK: - To Entity

    func toEntity(from model: EmotionCard, in context: NSManagedObjectContext) -> EmotionEntity {
        let entity = EmotionEntity(context: context)
        entity.id = model.id
        entity.typeRaw = model.type.rawValue
        entity.timestamp = model.date
        entity.tagsActivity = makeTagEntities(from: model.tags.activity, context: context)
        entity.tagsPeople = makeTagEntities(from: model.tags.people, context: context)
        entity.tagsLocation = makeTagEntities(from: model.tags.location, context: context)
        return entity
    }

    private func makeTagEntity(from tag: EmotionTag, context: NSManagedObjectContext) -> EmotionTagEntity {
        let entity = EmotionTagEntity(context: context)
        entity.id = tag.id
        entity.name = tag.name
        return entity
    }

    private func makeTagEntities(from tags: [EmotionTag], context: NSManagedObjectContext) -> Set<EmotionTagEntity> {
        Set(tags.map { makeTagEntity(from: $0, context: context) })
    }

    // MARK: - To DTO

    func toDTO(from model: EmotionCard) -> EmotionDTO {
        EmotionDTO(
            id: model.id,
            typeRaw: model.type.rawValue,
            timestamp: model.date.timeIntervalSince1970,
            activityTagNames: model.tags.activity.map { $0.name ?? "" },
            peopleTagNames: model.tags.people.map { $0.name ?? "" },
            locationTagNames: model.tags.location.map { $0.name ?? "" }
        )

    }

    func update(entity: EmotionEntity, with model: EmotionCard, in context: NSManagedObjectContext) {
        entity.id = model.id
        entity.typeRaw = model.type.rawValue
        entity.timestamp = model.date


        entity.tagsActivity?.forEach { context.delete($0) }
        entity.tagsPeople?.forEach { context.delete($0) }
        entity.tagsLocation?.forEach { context.delete($0) }

        entity.tagsActivity = Set(model.tags.activity.map {
            let tagEntity = EmotionTagEntity(context: context)
            tagEntity.id = $0.id
            tagEntity.name = $0.name
            tagEntity.emotionActivity = entity
            return tagEntity
        })

        entity.tagsPeople = Set(model.tags.people.map {
            let tagEntity = EmotionTagEntity(context: context)
            tagEntity.id = $0.id
            tagEntity.name = $0.name
            tagEntity.emotionPeople = entity
            return tagEntity
        })

        entity.tagsLocation = Set(model.tags.location.map {
            let tagEntity = EmotionTagEntity(context: context)
            tagEntity.id = $0.id
            tagEntity.name = $0.name
            tagEntity.emotionLocation = entity
            return tagEntity
        })
    }

    // MARK: - From DTO

    func fromDTO(_ dto: EmotionDTO) -> EmotionCard {
        EmotionCard(
            id: dto.id,
            type: EmotionType(rawValue: dto.typeRaw) ?? .placeholder,
            date: Date(timeIntervalSince1970: dto.timestamp),
            tags: EmotionTags(
                activity: dto.activityTagNames.map { EmotionTag(id: UUID(), name: $0) },
                people: dto.peopleTagNames.map { EmotionTag(id: UUID(), name: $0) },
                location: dto.locationTagNames.map { EmotionTag(id: UUID(), name: $0) }
            )
        )
    }
}
