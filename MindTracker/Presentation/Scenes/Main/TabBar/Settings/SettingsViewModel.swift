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

    let backgroundColor = UITheme.Colors.background
    let textColor = UITheme.Colors.appWhite

    let title = LocalizedKey.Settings.title
    let titleFont = UITheme.Font.SettingsScene.title

    let userAvatar = UITheme.Icons.SettingsScene.profilePlaceholder
    let userNameFont = UITheme.Font.SettingsScene.username
    let userNameColor = UITheme.Colors.appWhite
    let userNameLabel = LocalizedKey.Settings.userName

    let reminderIcon = UITheme.Icons.SettingsScene.reminders
    let reminderLabel = LocalizedKey.Settings.remainderSwitch
    let reminderFont = UITheme.Font.SettingsScene.remindersTitle

    let deleteReminderIcon = UITheme.Icons.SettingsScene.delete

    let addReminderButtonLabel = LocalizedKey.Settings.addRemainderButton

    let faceIdIcon = UITheme.Icons.SettingsScene.faceId
    let faceIdLabel = LocalizedKey.Settings.faceIdSwitch
    let faceIdFont = UITheme.Font.SettingsScene.loginSwitchTitle

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
