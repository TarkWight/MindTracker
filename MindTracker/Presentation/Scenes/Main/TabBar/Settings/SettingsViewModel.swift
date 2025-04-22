//
//  SettingsViewModel.swift
//  MindTracker
//
//  Created by Tark Wight on 24.02.2025.
//

import Foundation
import UIKit

final class SettingsViewModel: ViewModel {
    weak var coordinator: SettingsCoordinatorProtocol?

    let backgroundColor = AppColors.background
    let textColor = AppColors.appWhite

    let title = LocalizedKey.settingsViewTitle
    let titleFont = Typography.header1

    let userAvatar = AppIcons.settingsProfilePlaceholder
    let userNameFont = Typography.header3
    let userNameColor = AppColors.appWhite
    let userNameLabel = LocalizedKey.settingsUserName

    let reminderIcon = AppIcons.settingsReminders
    let reminderLabel = LocalizedKey.settingsReminderSwitch
    let reminderFont = Typography.body

    let deleteReminderIcon = AppIcons.settingsDelete

    let addReminderButtonLabel = LocalizedKey.settingsAddReminderButton

    let faceIdIcon = AppIcons.settingsFaceId
    let faceIdLabel = LocalizedKey.settingsFaceIdSwitch
    let faceIdFont = Typography.body

    var reminderTime = "20:00"

    var isReminderEnabled = true
    var isFingerprintEnabled = false

    init(coordinator: SettingsCoordinatorProtocol) {
        self.coordinator = coordinator
    }

    func handle(_ event: Event) {
        switch event {
        case .turnOnFaceID:
            turnOnFaceID()
        case .turnOffFaceID:
            turnOffFaceID()
        }
    }
}

extension SettingsViewModel {
    enum Event {
        case turnOnFaceID
        case turnOffFaceID
    }

    private func turnOnFaceID() {
        print("Face ID turned on")
    }

    private func turnOffFaceID() {
        print("Face ID turned off")
    }
}
