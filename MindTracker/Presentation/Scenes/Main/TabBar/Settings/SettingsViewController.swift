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

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewModel.backgroundColor

        setupTitle()
        setupUI()
        setupConstraints()
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
        // Фото профиля
        profileImageView.image = viewModel.userAvatar
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = UIConstants.profileImageSize / 2
        profileImageView.clipsToBounds = true

        // Имя пользователя
        userNameLabel.text = viewModel.userNameLabel
        userNameLabel.font = viewModel.userNameFont
        userNameLabel.textColor = viewModel.textColor
        userNameLabel.textAlignment = .center

        // Блок "Присылать напоминания"
        reminderIcon.image = viewModel.reminderIcon
        reminderIcon.contentMode = .scaleAspectFit

        reminderLabel.text = viewModel.reminderLabel
        reminderLabel.font = viewModel.reminderFont
        reminderLabel.textColor = viewModel.textColor

        reminderSwitch.isOn = viewModel.isReminderEnabled

        reminderView.addSubview(reminderIcon)
        reminderView.addSubview(reminderLabel)
        reminderView.addSubview(reminderSwitch)

        // Кнопка выбора времени с иконкой удаления
        let reminderButtonConfig = ButtonConfiguration(
            title: viewModel.reminderTime,
            textColor: .white,
            font: .systemFont(ofSize: 16, weight: .medium),
            fontSize: 16,
            icon: viewModel.deleteReminderIcon,
            iconSize: 24,
            backgroundColor: .darkGray,
            buttonHeight: UIConstants.reminderButtonHeight,
            cornerRadius: UIConstants.buttonCornerRadius,
            padding: 16,
            iconPosition: .right
        )
        reminderTimeButton.configure(with: reminderButtonConfig)

        // Кнопка "Добавить напоминание"
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

        // Блок "Вход по отпечатку пальца / FaceID"
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
        [profileImageView,
         userNameLabel, reminderView,
         reminderIcon, reminderLabel,
         reminderSwitch, reminderTimeButton,
         addReminderButton,
         fingerprintView, fingerprintIcon,
         fingerprintLabel, fingerprintSwitch]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview($0)
            }

        NSLayoutConstraint.activate([
            // Фото профиля
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.topPadding),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: UIConstants.profileImageSize),
            profileImageView.heightAnchor.constraint(equalToConstant: UIConstants.profileImageSize),

            // Имя пользователя
            userNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: UIConstants.profileSpacing),
            userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Блок "Присылать напоминания"
            reminderView.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: UIConstants.blockSpacing),
            reminderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.sidePadding),
            reminderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.sidePadding),
            reminderView.heightAnchor.constraint(equalToConstant: UIConstants.reminderButtonHeight),

            reminderIcon.leadingAnchor.constraint(equalTo: reminderView.leadingAnchor),
            reminderIcon.centerYAnchor.constraint(equalTo: reminderView.centerYAnchor),
            reminderIcon.widthAnchor.constraint(equalToConstant: UIConstants.iconSize),
            reminderIcon.heightAnchor.constraint(equalToConstant: UIConstants.iconSize),

            reminderLabel.leadingAnchor.constraint(equalTo: reminderIcon.trailingAnchor, constant: UIConstants.iconTextSpacing),
            reminderLabel.centerYAnchor.constraint(equalTo: reminderView.centerYAnchor),

            reminderSwitch.trailingAnchor.constraint(equalTo: reminderView.trailingAnchor),
            reminderSwitch.centerYAnchor.constraint(equalTo: reminderView.centerYAnchor),
            reminderSwitch.widthAnchor.constraint(equalToConstant: 50),
            reminderSwitch.heightAnchor.constraint(equalToConstant: 32),

            // Поле с временем
            reminderTimeButton.topAnchor.constraint(equalTo: reminderView.bottomAnchor, constant: UIConstants.blockSpacing),
            reminderTimeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.sidePadding),
            reminderTimeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.sidePadding),

            // Кнопка "Добавить напоминание"
            addReminderButton.topAnchor.constraint(equalTo: reminderTimeButton.bottomAnchor, constant: UIConstants.buttonSpacing),
            addReminderButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.sidePadding),
            addReminderButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.sidePadding),

            // Блок "Вход по отпечатку пальца"
            fingerprintView.topAnchor.constraint(equalTo: addReminderButton.bottomAnchor, constant: UIConstants.blockSpacing),
            fingerprintView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.sidePadding),
            fingerprintView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.sidePadding),
            fingerprintView.heightAnchor.constraint(equalToConstant: UIConstants.reminderButtonHeight),

            fingerprintIcon.leadingAnchor.constraint(equalTo: fingerprintView.leadingAnchor),
            fingerprintIcon.centerYAnchor.constraint(equalTo: fingerprintView.centerYAnchor),
            fingerprintIcon.widthAnchor.constraint(equalToConstant: UIConstants.iconSize),
            fingerprintIcon.heightAnchor.constraint(equalToConstant: UIConstants.iconSize),

            fingerprintLabel.leadingAnchor.constraint(equalTo: fingerprintIcon.trailingAnchor, constant: UIConstants.iconTextSpacing),
            fingerprintLabel.centerYAnchor.constraint(equalTo: fingerprintView.centerYAnchor),

            fingerprintSwitch.trailingAnchor.constraint(equalTo: fingerprintView.trailingAnchor),
            fingerprintSwitch.centerYAnchor.constraint(equalTo: fingerprintView.centerYAnchor),
            fingerprintSwitch.widthAnchor.constraint(equalToConstant: 50),
            fingerprintSwitch.heightAnchor.constraint(equalToConstant: 32),
        ])
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
        static let reminderButtonHeight: CGFloat = 64
        static let deleteButtonSize: CGFloat = 48
        static let buttonSpacing: CGFloat = 16
        static let addButtonHeight: CGFloat = 56
        static let buttonCornerRadius: CGFloat = 20
    }
}
