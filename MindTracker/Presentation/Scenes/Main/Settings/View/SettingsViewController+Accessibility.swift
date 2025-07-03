//
//  SettingsViewController+Accessibility.swift
//  MindTracker
//
//  Created by Tark Wight on 03.07.2025.
//

import UIKit

extension SettingsViewController {

    enum SettingsAccessibility {
        static let view = "tab_settings_vc"

        static let titleLabel = "settings_title_label"
        static let profileImage = "settings_profile_image"
        static let userNameLabel = "settings_user_name"

        static let reminderContainer = "settings_reminder_container"
        static let reminderIcon = "settings_reminder_icon"
        static let reminderLabel = "settings_reminder_label"
        static let reminderSwitch = "settings_reminder_switch"
        static let addReminderButton = "settings_add_reminder_button"
        static let remindersTableView = "settings_reminders_table"

        static let faceIdContainer = "settings_faceid_container"
        static let faceIdIcon = "settings_faceid_icon"
        static let faceIdLabel = "settings_faceid_label"
        static let faceIdSwitch = "settings_faceid_switch"
    }
}
