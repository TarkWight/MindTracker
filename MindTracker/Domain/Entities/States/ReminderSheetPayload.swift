//
//  ReminderSheetPayload.swift
//  MindTracker
//
//  Created by Tark Wight on 11.05.2025.
//

import Foundation

enum ReminderSheetPayload {
    case create
    case update(id: UUID, time: Date)
}
