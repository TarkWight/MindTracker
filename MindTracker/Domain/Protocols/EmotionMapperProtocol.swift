//
//  EmotionMapperProtocol.swift
//  MindTracker
//
//  Created by Tark Wight on 25.04.2025.
//

import Foundation
import CoreData

protocol EmotionMapperProtocol: Sendable {
    func toDomain(from entity: EmotionEntity) -> EmotionCard
    func toEntity(from model: EmotionCard, in context: NSManagedObjectContext) -> EmotionEntity
    func update(entity: EmotionEntity, with model: EmotionCard, in context: NSManagedObjectContext)
}
