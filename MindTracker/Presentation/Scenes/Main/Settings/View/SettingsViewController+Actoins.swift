//
//  SettingsViewController+Actoins.swift
//  MindTracker
//
//  Created by Tark Wight on 03.07.2025.
//

import UIKit

// MARK: - Actions
extension SettingsViewController {

    @objc func avatarTapped() {
        viewModel.handle(.avatarTapped)
    }

    @objc func reminderSwitchChanged(_ sender: UISwitch) {
        viewModel.handle(.remindSwitcherTapped(sender.isOn))
    }

    @objc func biometrySwitchChanged(_ sender: UISwitch) {
        viewModel.handle(.biometrySwitcherTapped(sender.isOn))
    }

    @objc func addRemindButtonTapped() {
        self.viewModel.handle(.addReminderTapped)
    }
}
