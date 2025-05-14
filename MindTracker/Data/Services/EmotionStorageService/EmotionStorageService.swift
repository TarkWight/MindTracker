//
//  EmotionStorageService.swift
//  MindTracker
//
//  Created by Tark Wight on 25.04.2025.
//

import Foundation
@preconcurrency import CoreData

final class EmotionStorageService: EmotionStorageServiceProtocol {

    private let context: NSManagedObjectContext
    private let mapper: EmotionMapperProtocol

    init(context: NSManagedObjectContext, mapper: EmotionMapperProtocol) {
        self.context = context
        self.mapper = mapper
    }

    func saveEmotion(_ emotion: EmotionCard) async throws {
        await context.perform {
            _ = self.mapper.toEntity(from: emotion, in: self.context)
        }
        try await contextSave()
    }

    func fetchEmotions() async throws -> [EmotionCard] {
        try await context.perform {
            let request = EmotionEntity.typedFetchRequest
            let entities = try self.context.fetch(request)
            return entities.map { self.mapper.toDomain(from: $0) }
        }
    }

    func deleteEmotion(by id: UUID) async throws {
        try await context.perform {
            let request = EmotionEntity.typedFetchRequest
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            let emotions = try self.context.fetch(request)
            emotions.forEach { self.context.delete($0) }
        }
        try await contextSave()
    }

    func deleteAllEmotions() async throws {
        try await context.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EmotionEntity")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try self.context.execute(deleteRequest)
        }
        try await contextSave()
    }

    private func contextSave() async throws {
        try await context.perform {
            if self.context.hasChanges {
                try self.context.save()
            }
        }
    }
}
