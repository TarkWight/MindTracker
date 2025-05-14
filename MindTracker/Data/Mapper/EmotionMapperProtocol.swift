//
//  EmotionMapperProtocol.swift
//  MindTracker
//
//  Created by Tark Wight on 25.04.2025.
//

import Foundation
import CoreData

protocol EmotionMapperProtocol: Sendable {
    func toDomain(from entity: EmotionEntity) -> EmotionCardModel
    func toEntity(from model: EmotionCardModel, in context: NSManagedObjectContext) -> EmotionEntity
    func toDTO(from model: EmotionCardModel) -> EmotionDTO
    func fromDTO(_ dto: EmotionDTO) -> EmotionCardModel
}
