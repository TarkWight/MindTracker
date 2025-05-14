//
//  EmotionDTO.swift
//  MindTracker
//
//  Created by Tark Wight on 25.04.2025.
//

import Foundation

struct EmotionDTO: Codable {
    let id: UUID
    let typeRaw: String
    let timestamp: TimeInterval
    let activityTagNames: [String]
    let peopleTagNames: [String]
    let locationTagNames: [String]
}
