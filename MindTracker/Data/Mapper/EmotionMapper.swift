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
        entity.tagsActivity = makeTagEntities(from: model.tags.activity, context: context) // Value of optional type '[EmotionTag]?' must be unwrapped to a value of type '[EmotionTag]'
        entity.tagsPeople = makeTagEntities(from: model.tags.people, context: context) // Value of optional type '[EmotionTag]?' must be unwrapped to a value of type '[EmotionTag]'
        entity.tagsLocation = makeTagEntities(from: model.tags.location, context: context) // Value of optional type '[EmotionTag]?' must be unwrapped to a value of type '[EmotionTag]'
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
            activityTagNames: model.tags.activity.map { $0.name ?? "" }, // Cannot convert value of type 'String?' to expected argument type '[String]'
            peopleTagNames: model.tags.people.map { $0.name ?? "" }, // Cannot convert value of type 'String?' to expected argument type '[String]'
            locationTagNames: model.tags.location.map { $0.name ?? "" } // Cannot convert value of type 'String?' to expected argument type '[String]'
        )
        /*
         struct EmotionCardModel {
             let id: UUID
             let type: EmotionType
             let date: Date
             let tags: EmotionTags
         }
         
         struct EmotionTags {
             let activity: [EmotionTag]?
             let people: [EmotionTag]?
             let location: [EmotionTag]?
         }

         */
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
