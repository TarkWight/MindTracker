//
//  EmotionCard.swift
//  MindTracker
//
//  Created by Tark Wight on 02.03.2025.
//

import Foundation

struct EmotionCard {
    let id: UUID
    let type: EmotionType
    let date: Date
    let tags: EmotionTags
}
