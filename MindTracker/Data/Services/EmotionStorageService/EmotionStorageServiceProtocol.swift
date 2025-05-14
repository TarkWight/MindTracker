//
//  EmotionStorageServiceProtocol.swift
//  MindTracker
//
//  Created by Tark Wight on 25.04.2025.
//

import Foundation

protocol EmotionStorageServiceProtocol: Sendable {
    func saveEmotion(_ emotion: EmotionCard) async throws
    func fetchEmotions() async throws -> [EmotionCard]
    func deleteEmotion(by id: UUID) async throws
    func deleteAllEmotions() async throws
}
