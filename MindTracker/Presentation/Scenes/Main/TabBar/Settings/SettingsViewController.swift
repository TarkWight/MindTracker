//
//  SettingsViewController.swift
//  MindTracker
//
//  Created by Tark Wight on 24.02.2025.
//

import UIKit

final class SettingsViewController: UIViewController {
    let viewModel: SettingsViewModel

    private let profileImageView = UIImageView()
    private let userNameLabel = UILabel()
    private let reminderView = UIView()
    private let reminderIcon = UIImageView()
    private let reminderLabel = UILabel()
    private let reminderSwitch = UISwitch()
    private let reminderTimeButton = CustomButton()
    private let addReminderButton = CustomButton()
    private let fingerprintView = UIView()
    private let fingerprintIcon = UIImageView()
    private let fingerprintLabel = UILabel()
    private let fingerprintSwitch = UISwitch()

    private let timePicker = UIDatePicker()

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewModel.backgroundColor

        setupTitle()
        setupUI()
        setupConstraints()
        setupTimePicker()
    }

    private func setupTitle() {
        let titleLabel = UILabel()
        titleLabel.text = viewModel.title
        titleLabel.font = viewModel.titleFont
        titleLabel.textColor = viewModel.textColor
        titleLabel.sizeToFit()

        let leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }

    private func setupUI() {
        profileImageView.image = viewModel.userAvatar
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = UIConstants.profileImageSize / 2
        profileImageView.clipsToBounds = true

        userNameLabel.text = viewModel.userNameLabel
        userNameLabel.font = viewModel.userNameFont
        userNameLabel.textColor = viewModel.textColor
        userNameLabel.textAlignment = .center

        reminderIcon.image = viewModel.reminderIcon
        reminderIcon.contentMode = .scaleAspectFit

        reminderLabel.text = viewModel.reminderLabel
        reminderLabel.font = viewModel.reminderFont
        reminderLabel.textColor = viewModel.textColor

        reminderSwitch.isOn = viewModel.isReminderEnabled

        reminderView.addSubview(reminderIcon)
        reminderView.addSubview(reminderLabel)
        reminderView.addSubview(reminderSwitch)

        let reminderButtonConfig = ButtonConfiguration(
            title: viewModel.reminderTime,
            textColor: UITheme.Colors.appWhite,
            font: UITheme.Font.SettingsScene.addReminderButton,
            fontSize: 16,
            icon: viewModel.deleteReminderIcon,
            iconSize: 48,
            backgroundColor: UITheme.Colors.appGray,
            buttonHeight: UIConstants.reminderButtonHeight,
            cornerRadius: UIConstants.buttonCornerRadius,
            padding: 8,
            iconPosition: .right
        )
        reminderTimeButton.configure(with: reminderButtonConfig)
        reminderTimeButton.addTarget(self, action: #selector(showTimePicker), for: .touchUpInside)

        let addReminderButtonConfig = ButtonConfiguration(
            title: viewModel.addReminderButtonLabel,
            textColor: .black,
            font: .systemFont(ofSize: 16, weight: .medium),
            fontSize: 16,
            icon: nil,
            iconSize: 0,
            backgroundColor: .white,
            buttonHeight: UIConstants.addButtonHeight,
            cornerRadius: UIConstants.buttonCornerRadius,
            padding: 16,
            iconPosition: .left
        )
        addReminderButton.configure(with: addReminderButtonConfig)

        fingerprintIcon.image = viewModel.faceIdIcon
        fingerprintIcon.contentMode = .scaleAspectFit

        fingerprintLabel.text = viewModel.faceIdLabel
        fingerprintLabel.font = viewModel.faceIdFont
        fingerprintLabel.textColor = viewModel.textColor

        fingerprintSwitch.isOn = viewModel.isFingerprintEnabled

        fingerprintView.addSubview(fingerprintIcon)
        fingerprintView.addSubview(fingerprintLabel)
        fingerprintView.addSubview(fingerprintSwitch)
    }

    private func setupConstraints() {
        [
            profileImageView,
            userNameLabel,
            reminderView,
            reminderIcon,
            reminderLabel,
            reminderSwitch,
            reminderTimeButton,
            addReminderButton,
            fingerprintView,
            fingerprintIcon,
            fingerprintLabel,
            fingerprintSwitch,
        ]
        .forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: UIConstants.topPadding
            ),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: UIConstants.profileImageSize),
            profileImageView.heightAnchor.constraint(equalToConstant: UIConstants.profileImageSize),

            userNameLabel.topAnchor.constraint(
                equalTo: profileImageView.bottomAnchor,
                constant: UIConstants.profileSpacing
            ),
            userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            reminderView.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: UIConstants.blockSpacing),
            reminderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.sidePadding),
            reminderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.sidePadding),
            reminderView.heightAnchor.constraint(equalToConstant: UIConstants.reminderButtonHeight),

            reminderIcon.leadingAnchor.constraint(equalTo: reminderView.leadingAnchor),
            reminderIcon.centerYAnchor.constraint(equalTo: reminderView.centerYAnchor),
            reminderIcon.widthAnchor.constraint(equalToConstant: UIConstants.iconSize),
            reminderIcon.heightAnchor.constraint(equalToConstant: UIConstants.iconSize),

            reminderLabel.leadingAnchor.constraint(
                equalTo: reminderIcon.trailingAnchor,
                constant: UIConstants.iconTextSpacing
            ),
            reminderLabel.centerYAnchor.constraint(equalTo: reminderView.centerYAnchor),

            reminderSwitch.trailingAnchor.constraint(equalTo: reminderView.trailingAnchor),
            reminderSwitch.centerYAnchor.constraint(equalTo: reminderView.centerYAnchor),

            reminderTimeButton.topAnchor.constraint(equalTo: reminderView.bottomAnchor, constant: UIConstants.blockSpacing),
            reminderTimeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.sidePadding),
            reminderTimeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.sidePadding),

            addReminderButton.topAnchor.constraint(equalTo: reminderTimeButton.bottomAnchor, constant: UIConstants.buttonSpacing),
            addReminderButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.sidePadding),
            addReminderButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.sidePadding),

            fingerprintView.topAnchor.constraint(equalTo: addReminderButton.bottomAnchor, constant: UIConstants.blockSpacing),
            fingerprintView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.sidePadding),
            fingerprintView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.sidePadding),
            fingerprintView.heightAnchor.constraint(equalToConstant: UIConstants.reminderButtonHeight),

            fingerprintIcon.leadingAnchor.constraint(equalTo: fingerprintView.leadingAnchor),
            fingerprintIcon.centerYAnchor.constraint(equalTo: fingerprintView.centerYAnchor),

            fingerprintLabel.leadingAnchor.constraint(equalTo: fingerprintIcon.trailingAnchor, constant: UIConstants.iconTextSpacing),
            fingerprintLabel.centerYAnchor.constraint(equalTo: fingerprintView.centerYAnchor),

            fingerprintSwitch.trailingAnchor.constraint(equalTo: fingerprintView.trailingAnchor),
            fingerprintSwitch.centerYAnchor.constraint(equalTo: fingerprintView.centerYAnchor),
        ])
    }

    private func setupTimePicker() {
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.tintColor = UITheme.Colors.appGray
    }

    @objc private func showTimePicker() {
        let alertController = UIAlertController(title: "Выберите время", message: nil, preferredStyle: .actionSheet)
        alertController.view.addSubview(timePicker)

        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            self.reminderTimeButton.setTitle(formatter.string(from: self.timePicker.date), for: .normal)
        }

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }

    deinit {
        ConsoleLogger.classDeInitialized()
    }
}

extension SettingsViewController {
    enum UIConstants {
        static let topPadding: CGFloat = 76
        static let sidePadding: CGFloat = 24
        static let profileImageSize: CGFloat = 96
        static let profileSpacing: CGFloat = 12
        static let blockSpacing: CGFloat = 32
        static let iconSize: CGFloat = 24
        static let iconTextSpacing: CGFloat = 8
        static let reminderButtonHeight: CGFloat = 56
        static let deleteButtonSize: CGFloat = 48
        static let buttonSpacing: CGFloat = 16
        static let addButtonHeight: CGFloat = 56
        static let buttonCornerRadius: CGFloat = 28
    }
}
