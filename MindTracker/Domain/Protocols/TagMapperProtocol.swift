//
//  TagMapperProtocol.swift
//  MindTracker
//
//  Created by Tark Wight on 24.05.2025.
//

import Foundation
import CoreData

protocol TagMapperProtocol: Sendable {
    func toDomain(from entity: EmotionTagEntity) -> EmotionTag
    func toEntity(from model: EmotionTag, type: TagType, context: NSManagedObjectContext) -> EmotionTagEntity
}
