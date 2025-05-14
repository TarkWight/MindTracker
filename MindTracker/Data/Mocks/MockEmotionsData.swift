//
//  MockEmotionsData.swift
//  MindTracker
//
//  Created by Tark Wight on 02.03.2025.
//

import Foundation

enum MockDataType {
    case empty
//    case one
//    case two
//    case three
//    case four
//    case five
//    case sixteen
}

enum MockEmotionsData {
    private static let calendar = Calendar.current

    private static func randomDate(withinDays days: Int) -> Date {
        let randomDayOffset = Int.random(in: 0 ..< days)
        let randomHourOffset = Int.random(in: 0 ..< 24)
        let randomMinuteOffset = Int.random(in: 0 ..< 60)

        var dateComponents = DateComponents()
        dateComponents.day = -randomDayOffset
        dateComponents.hour = -randomHourOffset
        dateComponents.minute = -randomMinuteOffset

        return calendar.date(byAdding: dateComponents, to: Date()) ?? Date()
    }

    static let empty: [EmotionCardModel] = []

//    static let one: [EmotionCardModel] = [
//        EmotionCardModel(type: .calmness, date: randomDate(withinDays: 1), tags: <#EmotionTags#>),
//    ]
//
//    static let two: [EmotionCardModel] = [
//        EmotionCardModel(type: .calmness, date: randomDate(withinDays: 1)),
//        EmotionCardModel(type: .anxiety, date: randomDate(withinDays: 2)),
//    ]
//
//    static let three: [EmotionCardModel] = [
//        EmotionCardModel(type: .burnout, date: randomDate(withinDays: 3)),
//        EmotionCardModel(type: .confidence, date: randomDate(withinDays: 5)),
//        EmotionCardModel(type: .happiness, date: randomDate(withinDays: 7)),
//    ]
//
//    static let four: [EmotionCardModel] = [
//        EmotionCardModel(type: .burnout, date: randomDate(withinDays: 3)),
//        EmotionCardModel(type: .confidence, date: randomDate(withinDays: 5)),
//        EmotionCardModel(type: .happiness, date: randomDate(withinDays: 7)),
//        EmotionCardModel(type: .rage, date: randomDate(withinDays: 10)),
//    ]
//
//    static let five: [EmotionCardModel] = [
//        EmotionCardModel(type: .burnout, date: randomDate(withinDays: 2)),
//        EmotionCardModel(type: .confidence, date: randomDate(withinDays: 4)),
//        EmotionCardModel(type: .happiness, date: randomDate(withinDays: 6)),
//        EmotionCardModel(type: .rage, date: randomDate(withinDays: 8)),
//        EmotionCardModel(type: .tension, date: randomDate(withinDays: 10)),
//    ]
//
//    static let sixteen: [EmotionCardModel] = (0 ..< 16).map { _ in
//        EmotionCardModel(
//            type: EmotionType.allCases.randomElement() ?? .placeholder,
//            date: randomDate(withinDays: 14)
//        )
//    }

    static func getMockData(for type: MockDataType) -> [EmotionCardModel] {
        switch type {
        case .empty: return empty
//        case .one: return one
//        case .two: return two
//        case .three: return three
//        case .four: return four
//        case .five: return five
//        case .sixteen: return sixteen
        }
    }
}
