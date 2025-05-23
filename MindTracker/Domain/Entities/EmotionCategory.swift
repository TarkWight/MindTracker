//
//  EmotionCategory.swift
//  MindTracker
//
//  Created by Tark Wight on 02.03.2025.
//

import UIKit

enum EmotionCategory: CaseIterable {
    case red
    case yellow
    case blue
    case green
    case none

    var localizedName: String {
        switch self {
        case .red:
            return LocalizedKey.EmotionCategory.red
        case .yellow:
            return LocalizedKey.EmotionCategory.yellow
        case .blue:
            return LocalizedKey.EmotionCategory.blue
        case .green:
            return LocalizedKey.EmotionCategory.green
        case .none:
            return ""
        }
    }

    var color: UIColor {
        switch self {
        case .red: return UIColor.cherryRed
        case .yellow: return UIColor.sunsetOrange
        case .blue: return UIColor.skyBlue
        case .green: return UIColor.limeGreen
        case .none: return UIColor.clear
        }
    }
}
