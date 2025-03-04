//
//  DateFormatter+month.swift
//  MindTracker
//
//  Created by Tark Wight on 04.03.2025.
//

import Foundation

extension DateFormatter {
    static func formattedMonth(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "d MMMM"

        let fullDate = formatter.string(from: date)

        let languageCode = Locale.current.language.languageCode?.identifier ?? "en"

        let months: [String: String] = languageCode == "ru" ? [
            "января": "янв",
            "февраля": "фев",
            "марта": "мар",
            "апреля": "апр",
            "мая": "май",
            "июня": "июн",
            "июля": "июл",
            "августа": "авг",
            "сентября": "сен",
            "октября": "окт",
            "ноября": "ноя",
            "декабря": "дек"
        ] : [
            "January": "jan",
            "February": "feb",
            "March": "mar",
            "April": "apr",
            "May": "may",
            "June": "jun",
            "July": "jul",
            "August": "aug",
            "September": "sep",
            "October": "oct",
            "November": "nov",
            "December": "dec",
        ]

        var formattedString = fullDate
        for (full, short) in months where formattedString.contains(full) {
            formattedString = formattedString.replacingOccurrences(of: full, with: short)
        }

        return formattedString
    }
}
