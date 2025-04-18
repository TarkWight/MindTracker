//
//  EmotionCardModel.swift
//  MindTracker
//
//  Created by Tark Wight on 02.03.2025.
//

import Foundation
import UIKit

struct EmotionCardModel {
    let type: EmotionType
    let date: Date

    var name: String {
        return type.name
    }

    var color: UIColor {
        return type.category.color
    }

    var icon: UIImage {
        return type.icon
    }

    var formattedDate: String {
        return date.formattedEmotionDate()
    }
}
