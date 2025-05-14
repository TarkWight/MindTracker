//
//  EmotionStorageServiceProtocol.swift
//  MindTracker
//
//  Created by Tark Wight on 25.04.2025.
//

import Foundation

protocol EmotionStorageServiceProtocol: Sendable {
    func saveEmotion(_ emotion: EmotionCardModel) async throws
    func fetchEmotions() async throws -> [EmotionCardModel]
    func deleteEmotion(by id: UUID) async throws
    func deleteAllEmotions() async throws
}
