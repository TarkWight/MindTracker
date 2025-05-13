//
//  ReminderMapper.swift
//  MindTracker
//
//  Created by Tark Wight on 06.05.2025.
//

import Foundation

enum ReminderMapper {

    static func map(from dto: ReminderDTO) -> Reminder {
        return dto.toDomain()
    }

    static func map(from domain: Reminder) -> ReminderDTO {
        let formatter = ISO8601DateFormatter()
        let timeString = formatter.string(from: domain.time)

        return ReminderDTO(id: domain.id, timeString: timeString)
    }
}
