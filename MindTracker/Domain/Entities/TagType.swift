//
//  TagType.swift
//  MindTracker
//
//  Created by Tark Wight on 15.05.2025.
//

import Foundation

enum TagType: String {
    case activity
    case people
    case location

    var entityKeyPath: String {
        switch self {
        case .activity: return "emotionActivity"
        case .people: return "emotionPeople"
        case .location: return "emotionLocation"
        }
    }
}
