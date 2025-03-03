//
//  Date+Formatting.swift
//  MindTracker
//
//  Created by Tark Wight on 02.03.2025.
//

import Foundation

extension Date {
    func formattedEmotionDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "HH:mm"

        let calendar = Calendar.current
        if calendar.isDateInToday(self) {
            return "\(NSLocalizedString(LocalizedKey.EmotionsDate.today, comment: "")), \(formatter.string(from: self))"
        } else if calendar.isDateInYesterday(self) {
            return "\(NSLocalizedString(LocalizedKey.EmotionsDate.yesterday, comment: "")), \(formatter.string(from: self))"
        } else if let weekday = calendar.weekdaySymbols[safe: calendar.component(.weekday, from: self) - 1] {
            return "\(weekday), \(formatter.string(from: self))"
        } else {
            formatter.dateFormat = "d MMMM, HH:mm"
            return formatter.string(from: self)
        }
    }
}
