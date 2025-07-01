//
//  SettingsViewModelError.swift
//  MindTracker
//
//  Created by Tark Wight on 10.05.2025.
//

import Foundation

enum SettingsViewModelError: Error {
    case failedToLoadAvatar
    case failedToSaveAvatar
    case failedToUpdateAvatar
    case failedToDeleteAvatar
    case failedToLoadReminders
    case failedToCreateReminder
    case failedToDeleteReminder
    case failedToUpdateReminder
    case failedToSetFaceID
}

extension SettingsViewModelError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .failedToLoadAvatar:
            return "Не удалось загрузить аватар."
        case .failedToSaveAvatar:
            return "Не удалось сохранить аватар."
        case .failedToUpdateAvatar:
            return "Не удалось обновить аватар."
        case .failedToDeleteAvatar:
            return "Не удалось удалить аватар."
        case .failedToLoadReminders:
            return "Не удалось загрузить напоминания."
        case .failedToCreateReminder:
            return "Не удалось создать напоминание."
        case .failedToDeleteReminder:
            return "Не удалось удалить напоминание."
        case .failedToUpdateReminder:
            return "Не удалось обновить напоминание."
        case .failedToSetFaceID:
            return "Не удалось включить или выключить Face ID."
        }
    }
}
