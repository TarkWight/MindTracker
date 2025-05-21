//
//  TagStorageService.swift
//  MindTracker
//
//  Created by Tark Wight on 15.05.2025.
//

import Foundation
import CoreData

final class TagStorageService: TagStorageServiceProtocol, @unchecked Sendable {

    private let context: NSManagedObjectContext
    private let defaultTags: [TagType: [String]]

    init(context: NSManagedObjectContext, defaultTags: [TagType: [String]]) {
        self.context = context
        self.defaultTags = defaultTags
    }

    func fetchAllTags() async throws -> EmotionTags {
        try await context.perform {
            let request = EmotionTagEntity.typedFetchRequest
            let allTags = try self.context.fetch(request)

            let activity = allTags.filter { $0.tagTypeRaw == TagType.activity.rawValue }.compactMap { $0.name }
            let people   = allTags.filter { $0.tagTypeRaw == TagType.people.rawValue }.compactMap { $0.name }
            let location = allTags.filter { $0.tagTypeRaw == TagType.location.rawValue }.compactMap { $0.name }

            return EmotionTags(
                activity: Set(activity).map { EmotionTag(id: UUID(), name: $0, tagTypeRaw: TagType.activity.rawValue) },
                people: Set(people).map { EmotionTag(id: UUID(), name: $0, tagTypeRaw: TagType.people.rawValue) },
                location: Set(location).map { EmotionTag(id: UUID(), name: $0, tagTypeRaw: TagType.location.rawValue) }
            )
        }
    }

    func availableTags(for type: TagType) async throws -> [String] {
        try await context.perform {
            let request = EmotionTagEntity.typedFetchRequest
            request.predicate = NSPredicate(format: "%K != nil", type.entityKeyPath)
            let tags = try self.context.fetch(request)
            return tags.compactMap { $0.name }
        }
    }

    func addTag(_ name: String, for type: TagType) async throws {
        try await context.perform {
            let tag = EmotionTagEntity(context: self.context)
            tag.id = UUID()
            tag.name = name

            switch type {
            case .activity:
                tag.emotionActivity = EmotionEntity()
            case .people:
                tag.emotionPeople = EmotionEntity()
            case .location:
                tag.emotionLocation = EmotionEntity()
            }

            try self.saveIfNeeded()
        }
    }

    func removeTag(_ name: String, from type: TagType) async throws {
        try await context.perform {
            let request = EmotionTagEntity.typedFetchRequest
            request.predicate = NSPredicate(format: "name == %@ AND %K != nil", name, type.entityKeyPath)
            let tags = try self.context.fetch(request)
            tags.forEach { self.context.delete($0) }
            try self.saveIfNeeded()
        }
    }

    func seedDefaultTagsIfNeeded() async throws {
        try await context.perform {
            for (type, tags) in self.defaultTags {
                let request = EmotionTagEntity.typedFetchRequest
                request.predicate = NSPredicate(format: "%K != nil", type.entityKeyPath)

                let existingTagNames = try self.context.fetch(request).compactMap { $0.name }
                let missingTags = tags.filter { !existingTagNames.contains($0) }

                for tagName in missingTags {
                    let tag = EmotionTagEntity(context: self.context)
                    tag.id = UUID()
                    tag.name = tagName
                    tag.tagTypeRaw = type.rawValue
                }
            }

            try self.saveIfNeeded()
        }
    }

    private func saveIfNeeded() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
