//
//  EmotionType.swift
//  MindTracker
//
//  Created by Tark Wight on 02.03.2025.
//

import UIKit

enum EmotionType: CaseIterable {
    case rage, tension, envy, anxiety
    case excitement, delight, confidence, happiness
    case burnout, fatigue, depression, apathy
    case calmness, satisfaction, gratitude, security

    var name: String {
        switch self {
        case .rage: return LocalizedKey.EmotionType.rage
        case .tension: return LocalizedKey.EmotionType.tension
        case .envy: return LocalizedKey.EmotionType.envy
        case .anxiety: return LocalizedKey.EmotionType.anxiety
        case .excitement: return LocalizedKey.EmotionType.excitement
        case .delight: return LocalizedKey.EmotionType.delight
        case .confidence: return LocalizedKey.EmotionType.confidence
        case .happiness: return LocalizedKey.EmotionType.happiness
        case .burnout: return LocalizedKey.EmotionType.burnout
        case .fatigue: return LocalizedKey.EmotionType.fatigue
        case .depression: return LocalizedKey.EmotionType.depression
        case .apathy: return LocalizedKey.EmotionType.apathy
        case .calmness: return LocalizedKey.EmotionType.calmness
        case .satisfaction: return LocalizedKey.EmotionType.satisfaction
        case .gratitude: return LocalizedKey.EmotionType.gratitude
        case .security: return LocalizedKey.EmotionType.security
        }
    }

    var category: EmotionCategory {
        switch self {
        case .rage, .tension, .envy, .anxiety: return .red
        case .excitement, .delight, .confidence, .happiness: return .yellow
        case .burnout, .fatigue, .depression, .apathy: return .blue
        case .calmness, .satisfaction, .gratitude, .security: return .green
        }
    }

    var icon: UIImage {
        switch self {
        case .rage, .tension, .envy, .anxiety: return UITheme.Icons.EmotionCard.redIcon ?? UIImage()
        case .excitement, .delight, .confidence, .happiness: return UITheme.Icons.EmotionCard.yellowIcon ?? UIImage()
        case .burnout, .fatigue, .depression, .apathy: return UITheme.Icons.EmotionCard.blueIcon ?? UIImage()
        case .calmness, .satisfaction, .gratitude, .security: return UITheme.Icons.EmotionCard.greenIcon ?? UIImage()
        }
    }
}
