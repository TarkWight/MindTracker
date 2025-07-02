//
//  ReminderSchedulerService.swift
//  MindTracker
//
//  Created by Tark Wight on 24.05.2025.
//

import Foundation
import UserNotifications

final class ReminderSchedulerService: ReminderSchedulerServiceProtocol {
    func schedule(id: UUID, time: Date) async throws {
        let center = UNUserNotificationCenter.current()

        _ = try await center.requestAuthorization(options: [
            .alert, .sound, .badge,
        ])

        let content = UNMutableNotificationContent()
        content.title = LocalizedKey.reminderNotification
        content.body = DateFormatter.timeOnly.string(from: time)
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: time
        )

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: triggerDate,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: id.uuidString,
            content: content,
            trigger: trigger
        )

        try await center.add(request)
    }

    func cancel(id: UUID) throws {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [id.uuidString])
    }
}
