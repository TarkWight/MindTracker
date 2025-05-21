//
//  EmotionEventBus.swift
//  MindTracker
//
//  Created by Tark Wight on 15.05.2025.
//

import Combine

enum EmotionEvent {
    case added(EmotionCard)
    case updated(EmotionCard)
}

@MainActor
final class EmotionEventBus {
    static let shared = EmotionEventBus()

    private init() {}

    let emotionPublisher = PassthroughSubject<EmotionEvent, Never>()
}
