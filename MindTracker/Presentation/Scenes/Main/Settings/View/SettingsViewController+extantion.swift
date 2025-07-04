//
//  SettingsViewController+extantion.swift
//  MindTracker
//
//  Created by Tark Wight on 15.05.2025.
//

import UIKit

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        return 8
    }

    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        let spacer = UIView()
        spacer.backgroundColor = .clear
        return spacer
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.reminders.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int {
        return 1
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 64
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ReminderCell.reuseIdentifier,
                for: indexPath
            ) as? ReminderCell
        else {
            return UITableViewCell()
        }

        let reminder = viewModel.reminders[indexPath.section]
        let label = DateFormatter.timeOnly.string(from: reminder.time)

        cell.configure(with: reminder, label: label)

        cell.onTap = { [weak self] _, _ in
            self?.viewModel.handle(.remindTapped(reminder.id))
        }

        cell.onButtonTap = { [weak self] id in
            self?.viewModel.handle(.deleteReminderTapped(id))
        }

        return cell
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SettingsViewController {

    func reminderTapped(id: UUID, time: Date) {
        let pickerVC = ReminderPickerViewController()

        pickerVC.setInitialTime(from: time)

        pickerVC.onSave = { [weak self] hour, minute in
            self?.viewModel.handle(.updateReminder(id, hour, minute))
        }

        presentSheet(pickerVC)
    }

    func showError(_ error: SettingsViewModelError) {
        let alert = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }

    func presentSheet(_ pickerVC: ReminderPickerViewController) {
        pickerVC.modalPresentationStyle = .pageSheet

        if let sheet = pickerVC.sheetPresentationController {
            sheet.detents = [.custom { _ in
                return 300
            }]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 28
        }

        present(pickerVC, animated: true)
    }
}
