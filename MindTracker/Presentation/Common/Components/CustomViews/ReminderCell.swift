//
//  ReminderCell.swift
//  MindTracker
//
//  Created by Tark Wight on 11.05.2025.
//

import UIKit

final class ReminderCell: UITableViewCell {
    static let reuseIdentifier = "ReminderCell"

    private let containerView = UIView()
    private let reminderView = ReminderViewCell()

    var onTap: ((String, ReminderAction) -> Void)? {
        get { reminderView.onTap }
        set { reminderView.onTap = newValue }
    }

    var onButtonTap: ((UUID) -> Void)? {
        get { reminderView.onButtonTap }
        set { reminderView.onButtonTap = newValue }
    }

    func configure(with reminder: Reminder, label: String) {
        reminderView.setId(id: reminder.id)
        reminderView.setupCell(label: label)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
        setupConstraints()
        setupAccessibility()
    }

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.backgroundColor = .clear

        containerView.translatesAutoresizingMaskIntoConstraints = false
        reminderView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupConstraints() {
        containerView.addSubview(reminderView)
        contentView.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            containerView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),

            reminderView.topAnchor.constraint(equalTo: containerView.topAnchor),
            reminderView.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor
            ),
            reminderView.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor
            ),
            reminderView.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor
            ),
        ])
    }

    private func setupAccessibility() {
        accessibilityIdentifier = ReminderCellAccessibilityIdentifiers.container
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private enum ReminderCellAccessibilityIdentifiers {
    static let container = "reminder_cell_container"
}
