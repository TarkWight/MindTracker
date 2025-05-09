//
//  ReminderDTO.swift
//  MindTracker
//
//  Created by Tark Wight on 06.05.2025.
//

import Foundation

struct ReminderDTO: Decodable {
    let id: UUID
    var timeString: String

    func toDomain() -> Reminder {
        let formatter = ISO8601DateFormatter()
        let date = formatter.date(from: timeString) ?? Date()

        return Reminder(id: id, time: date)
    }
}
