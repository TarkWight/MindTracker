//
//  TagServiceProtocol.swift
//  MindTracker
//
//  Created by Tark Wight on 15.05.2025.
//

import Foundation

protocol TagServiceProtocol: Sendable {
    func availableTags(for type: TagType) async throws -> [String]
    func addTag(_ name: String, for type: TagType) async throws
    func removeTag(_ name: String, from type: TagType) async throws
    func fetchAllTags() async throws -> EmotionTags
    func seedDefaultTagsIfNeeded() async throws
}
