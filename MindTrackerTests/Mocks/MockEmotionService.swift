//
//  MockEmotionService.swift
//  MindTracker
//
//  Created by Tark Wight on 24.05.2025.
//

import Foundation
@testable import MindTracker

actor MockEmotionService: EmotionServiceProtocol {
    private var _savedEmotions: [EmotionCard] = []
    private var _deletedIDs: [UUID] = []
    private var _emotions: [EmotionCard] = []

    var savedEmotions: [EmotionCard] { _savedEmotions }
    var deletedIDs: [UUID] { _deletedIDs }

    func containsEmotion(withId id: UUID) async throws -> Bool {
        return _emotions.contains(where: { $0.id == id })
    }

    func saveEmotion(_ emotion: EmotionCard) async throws {
        _savedEmotions.append(emotion)
    }

    func updateEmotion(_ emotion: EmotionCard) async throws {
        if let index = _savedEmotions.firstIndex(where: { $0.id == emotion.id }) {
            _savedEmotions[index] = emotion
        }
    }

    func fetchEmotions() async throws -> [EmotionCard] {
        return _emotions
    }

    func deleteEmotion(by id: UUID) async throws {
        _deletedIDs.append(id)
    }

    func deleteAllEmotions() async throws {
        _savedEmotions.removeAll()
        _deletedIDs.removeAll()
    }
}
