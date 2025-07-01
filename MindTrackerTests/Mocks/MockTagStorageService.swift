//
//  MockTagStorageService.swift
//  MindTracker
//
//  Created by Tark Wight on 24.05.2025.
//

import Foundation
@testable import MindTracker

actor MockTagStorageService: TagServiceProtocol {
    private var _tags: [TagType: [String]] = [:]
    var tags: [TagType: [String]] { _tags }

    func fetchAllTags() async throws -> EmotionTags {
        EmotionTags(
            activity: _tags[.activity]?.map { EmotionTag(id: UUID(), name: $0, tagTypeRaw: TagType.activity.rawValue) } ?? [],
            people: _tags[.people]?.map { EmotionTag(id: UUID(), name: $0, tagTypeRaw: TagType.people.rawValue) } ?? [],
            location: _tags[.location]?.map { EmotionTag(id: UUID(), name: $0, tagTypeRaw: TagType.location.rawValue) } ?? []
        )
    }

    func availableTags(for type: TagType) async throws -> [String] {
        return _tags[type] ?? []
    }

    func addTag(_ name: String, for type: TagType) async throws {
        _tags[type, default: []].append(name)
    }

    func removeTag(_ name: String, from type: TagType) async throws {
        _tags[type]?.removeAll(where: { $0 == name })
    }

    func seedDefaultTagsIfNeeded() async throws {
        // No-op
    }
}
