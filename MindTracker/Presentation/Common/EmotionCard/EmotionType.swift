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
    case placeholder

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
        case .placeholder: return ""
        }
    }

    var description: String {
        switch self {
        case .rage: return LocalizedKey.EmotionDescription.rage
        case .tension: return LocalizedKey.EmotionDescription.tension
        case .envy: return LocalizedKey.EmotionDescription.envy
        case .anxiety: return LocalizedKey.EmotionDescription.anxiety
        case .excitement: return LocalizedKey.EmotionDescription.excitement
        case .delight: return LocalizedKey.EmotionDescription.delight
        case .confidence: return LocalizedKey.EmotionDescription.confidence
        case .happiness: return LocalizedKey.EmotionDescription.happiness
        case .burnout: return LocalizedKey.EmotionDescription.burnout
        case .fatigue: return LocalizedKey.EmotionDescription.fatigue
        case .depression: return LocalizedKey.EmotionDescription.depression
        case .apathy: return LocalizedKey.EmotionDescription.apathy
        case .calmness: return LocalizedKey.EmotionDescription.calmness
        case .satisfaction: return LocalizedKey.EmotionDescription.satisfaction
        case .gratitude: return LocalizedKey.EmotionDescription.gratitude
        case .security: return LocalizedKey.EmotionDescription.security
        case .placeholder: return ""
        }
    }

    var category: EmotionCategory {
        switch self {
        case .rage, .tension, .envy, .anxiety: return .red
        case .excitement, .delight, .confidence, .happiness: return .yellow
        case .burnout, .fatigue, .depression, .apathy: return .blue
        case .calmness, .satisfaction, .gratitude, .security: return .green
        case .placeholder: return .none
        }
    }

    var icon: UIImage {
        switch self {
        case .rage, .tension, .envy, .anxiety: return AppIcons.emotionRed ?? UIImage()
        case .excitement, .delight, .confidence, .happiness: return AppIcons.emotionYellow ?? UIImage()
        case .burnout, .fatigue, .depression, .apathy: return AppIcons.emotionBlue ?? UIImage()
        case .calmness, .satisfaction, .gratitude, .security: return AppIcons.emotionGreen ?? UIImage()
        case .placeholder: return AppIcons.emotionPlaceholder ?? UIImage()
        }
    }
}

extension EmotionType {
    static func random() -> EmotionType {
        return allCases.randomElement() ?? .calmness
    }
}
