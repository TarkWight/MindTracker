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
    case failedToUpdateReminder
    case failedToDeleteReminder

    case failedToSetBiometry
    case failedToLoadBiometryState
    case biometryUnavailable
    case biometryNotEnrolled
    case biometryFailed
    case biometryLockedOut
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
        case .failedToSetBiometry:
            return LocalizedKey.failedToSetBiometry
        case .failedToLoadBiometryState:
            return LocalizedKey.failedToLoadBiometryState
        case .biometryUnavailable:
            return LocalizedKey.biometryUnavailable
        case .biometryNotEnrolled:
            return LocalizedKey.biometryNotEnrolled
        case .biometryLockedOut:
            return LocalizedKey.biometryLockedOut
        case .biometryFailed:
            return LocalizedKey.biometryFailed
        }
    }
}
