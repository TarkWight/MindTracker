//
//  TagService.swift
//  MindTracker
//
//  Created by Tark Wight on 15.05.2025.
//

import Foundation
import CoreData

final class TagService: TagServiceProtocol, @unchecked Sendable {

    private let context: NSManagedObjectContext
    private let defaultTags: [TagType: [String]]
    private let mapper: TagMapperProtocol

    init(
        context: NSManagedObjectContext,
        defaultTags: [TagType: [String]],
        mapper: TagMapperProtocol
    ) {
        self.context = context
        self.defaultTags = defaultTags
        self.mapper = mapper
    }

    func fetchAllTags() async throws -> EmotionTags {
        try await context.perform {
            let request = EmotionTagEntity.typedFetchRequest
            let allTags = try self.context.fetch(request)

            return EmotionTags(
                activity: allTags.filter { $0.tagTypeRaw == TagType.activity.rawValue }.map { self.mapper.toDomain(from: $0) },
                people: allTags.filter { $0.tagTypeRaw == TagType.people.rawValue }.map { self.mapper.toDomain(from: $0) },
                location: allTags.filter { $0.tagTypeRaw == TagType.location.rawValue }.map { self.mapper.toDomain(from: $0) }
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
            let tag = self.mapper.toEntity(from: EmotionTag(id: UUID(), name: name, tagTypeRaw: type.rawValue), type: type, context: self.context)

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
                    _ = self.mapper.toEntity(from: EmotionTag(id: UUID(), name: tagName, tagTypeRaw: type.rawValue), type: type, context: self.context)
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
