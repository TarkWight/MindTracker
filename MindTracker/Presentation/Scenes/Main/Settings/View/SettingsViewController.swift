//
//  SettingsViewController.swift
//  MindTracker
//
//  Created by Tark Wight on 24.02.2025.
//

import Combine
import UIKit

final class SettingsViewController: UIViewController {

    let viewModel: SettingsViewModel
    private var cancellables = Set<AnyCancellable>()

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let remindersContainerView = UIView()
    private let remindersTableView = UITableView(frame: .zero, style: .plain)

    let titleLabel = UILabel()
    private let profileImageView = UIImageView()
    private let userNameLabel = UILabel()
    private let reminderView = UIView()
    private let reminderIcon = UIImageView()
    private let reminderLabel = UILabel()
    private let reminderSwitch = UISwitch()
    private let addReminderButton = CustomButton()
    private let faceIdView = UIView()
    private let faceIdIcon = UIImageView()
    private let faceIdLabel = UILabel()
    private let faceIdSwitch = UISwitch()

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SettingsVCStyleConstants.backgroundColor

        setupUI()
        viewModel.handle(.viewDidLoad)
        bindViewModel()
        setupAccessibility()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    deinit {
        ConsoleLogger.classDeInitialized()
    }
}

// MARK: - Setup
extension SettingsViewController {

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        setupTitle()
        setupProfileData()
        setupReminderBlock()
        setupRemindersContainerView()
        setupFaceIdBlock()
        setupConstraints()
    }

    func setupAccessibility() {
        view.accessibilityIdentifier = SettingsAccessibility.view
        titleLabel.accessibilityIdentifier = SettingsAccessibility.titleLabel
        profileImageView.accessibilityIdentifier = SettingsAccessibility.profileImage
        userNameLabel.accessibilityIdentifier = SettingsAccessibility.userNameLabel

        reminderView.accessibilityIdentifier = SettingsAccessibility.reminderContainer
        reminderIcon.accessibilityIdentifier = SettingsAccessibility.reminderIcon
        reminderLabel.accessibilityIdentifier = SettingsAccessibility.reminderLabel
        reminderSwitch.accessibilityIdentifier = SettingsAccessibility.reminderSwitch
        addReminderButton.accessibilityIdentifier = SettingsAccessibility.addReminderButton
        remindersTableView.accessibilityIdentifier = SettingsAccessibility.remindersTableView

        faceIdView.accessibilityIdentifier = SettingsAccessibility.faceIdContainer
        faceIdIcon.accessibilityIdentifier = SettingsAccessibility.faceIdIcon
        faceIdLabel.accessibilityIdentifier = SettingsAccessibility.faceIdLabel
        faceIdSwitch.accessibilityIdentifier = SettingsAccessibility.faceIdSwitch
    }

    func setupTitle() {
        titleLabel.text = LocalizedKey.settingsViewTitle
        titleLabel.font = SettingsVCStyleConstants.titleFont
        titleLabel.textColor = SettingsVCStyleConstants.textColor
        titleLabel.sizeToFit()
    }

    private func setupProfileData() {
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = SettingsVCSizeConstants.avatarSize / 2
        profileImageView.clipsToBounds = true
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(avatarTapped)))

        userNameLabel.font = SettingsVCStyleConstants.userNameFont
        userNameLabel.textColor = SettingsVCStyleConstants.textColor
        userNameLabel.textAlignment = .center
    }

    private func setupReminderBlock() {
        reminderIcon.image = AppIcons.settingsReminders
        reminderIcon.contentMode = .scaleAspectFit
        reminderIcon.image?.withRenderingMode(.alwaysTemplate)
        reminderIcon.tintColor = AppColors.appWhite

        reminderLabel.text = LocalizedKey.settingsReminderSwitch
        reminderLabel.font = SettingsVCStyleConstants.reminderFont
        reminderLabel.textColor = SettingsVCStyleConstants.textColor

        reminderView.addSubview(reminderIcon)
        reminderView.addSubview(reminderLabel)
        reminderView.addSubview(reminderSwitch)

        reminderSwitch.addTarget(self, action: #selector(reminderSwitchChanged(_:)), for: .valueChanged)

        let addReminderButtonConfig = ButtonConfiguration(
            title: LocalizedKey.settingsAddReminderButton,
            textColor: .appBlack,
            font: Typography.body,
            fontSize: 16,
            icon: nil,
            iconSize: 0,
            backgroundColor: .appWhite,
            buttonHeight: SettingsVCSizeConstants.addButtonHeight,
            cornerRadius: SettingsVCSizeConstants.addButtonHeight / 2,
            padding: 16,
            iconPosition: .left
        )
        addReminderButton.configure(with: addReminderButtonConfig)
        addReminderButton.addTarget(self, action: #selector(addRemindButtonTapped), for: .touchUpInside)
    }

    func setupRemindersContainerView() {
        remindersTableView.register(ReminderCell.self, forCellReuseIdentifier: ReminderCell.reuseIdentifier)
        remindersTableView.dataSource = self
        remindersTableView.delegate = self
        remindersTableView.separatorStyle = .none
        remindersTableView.backgroundColor = .clear
        remindersTableView.isScrollEnabled = true
        remindersTableView.showsVerticalScrollIndicator = false
        remindersTableView.rowHeight = UITableView.automaticDimension

        remindersContainerView.addSubview(remindersTableView)
        remindersTableView.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupFaceIdBlock() {
        faceIdIcon.image = AppIcons.settingsFaceId?.withRenderingMode(.alwaysTemplate)
        faceIdIcon.contentMode = .scaleAspectFill
        faceIdIcon.tintColor = AppColors.appWhite
        faceIdLabel.text = LocalizedKey.settingsFaceIdSwitch
        faceIdLabel.font = SettingsVCStyleConstants.faceIdFont
        faceIdLabel.textColor = SettingsVCStyleConstants.textColor

        faceIdView.addSubview(faceIdIcon)
        faceIdView.addSubview(faceIdLabel)
        faceIdView.addSubview(faceIdSwitch)

        faceIdSwitch.addTarget(self, action: #selector(biometrySwitchChanged(_:)), for: .valueChanged)
    }

    private func setupConstraints() {
        [
            titleLabel, profileImageView,
            userNameLabel, reminderView,
            reminderIcon, reminderLabel,
            reminderSwitch, remindersContainerView,
            addReminderButton, faceIdView,
            faceIdIcon, faceIdLabel,
            faceIdSwitch,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SettingsVCSpacingConstants.sideContentPadding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: SettingsVCSpacingConstants.sideContentPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -SettingsVCSpacingConstants.sideContentPadding),
            titleLabel.heightAnchor.constraint(equalToConstant: SettingsVCSizeConstants.labelSize),

            profileImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: SettingsVCSpacingConstants.spacingBetweenLabelAndAvatar),
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: SettingsVCSizeConstants.avatarSize),
            profileImageView.heightAnchor.constraint(equalToConstant: SettingsVCSizeConstants.avatarSize),

            userNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: SettingsVCSpacingConstants.spacingBetweenAvatarAndName),
            userNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            reminderView.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: SettingsVCSpacingConstants.spacingBetweenNameAndRemindToggle),
            reminderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: SettingsVCSpacingConstants.sideContentPadding),
            reminderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -SettingsVCSpacingConstants.sideContentPadding),
            reminderView.heightAnchor.constraint(equalToConstant: SettingsVCSizeConstants.remindToggleHeight),

            reminderIcon.leadingAnchor.constraint(equalTo: reminderView.leadingAnchor),
            reminderIcon.centerYAnchor.constraint(equalTo: reminderView.centerYAnchor),
            reminderIcon.widthAnchor.constraint(equalToConstant: SettingsVCSizeConstants.iconSize),
            reminderIcon.heightAnchor.constraint(equalToConstant: SettingsVCSizeConstants.iconSize),

            reminderLabel.leadingAnchor.constraint(equalTo: reminderIcon.trailingAnchor, constant: SettingsVCSpacingConstants.spacingBetweenIconAndLabel),
            reminderLabel.centerYAnchor.constraint(equalTo: reminderView.centerYAnchor),

            reminderSwitch.trailingAnchor.constraint(equalTo: reminderView.trailingAnchor),
            reminderSwitch.centerYAnchor.constraint(equalTo: reminderView.centerYAnchor),

            remindersContainerView.topAnchor.constraint(equalTo: reminderView.bottomAnchor, constant: SettingsVCSpacingConstants.spacingBetweenRemindToggleAndTable),
            remindersContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: SettingsVCSpacingConstants.sideContentPadding),
            remindersContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -SettingsVCSpacingConstants.sideContentPadding),

            remindersTableView.topAnchor.constraint(equalTo: remindersContainerView.topAnchor),
            remindersTableView.bottomAnchor.constraint(equalTo: remindersContainerView.bottomAnchor),
            remindersTableView.leadingAnchor.constraint(equalTo: remindersContainerView.leadingAnchor),
            remindersTableView.trailingAnchor.constraint(equalTo: remindersContainerView.trailingAnchor),

            remindersContainerView.bottomAnchor.constraint(lessThanOrEqualTo: remindersTableView.bottomAnchor, constant: 0).withPriority(.defaultLow),

            addReminderButton.topAnchor.constraint(equalTo: remindersContainerView.bottomAnchor, constant: SettingsVCSpacingConstants.spacingBetweenTableAndAddButton),
            addReminderButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: SettingsVCSpacingConstants.sideContentPadding),
            addReminderButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -SettingsVCSpacingConstants.sideContentPadding),

            faceIdView.topAnchor.constraint(equalTo: addReminderButton.bottomAnchor, constant: SettingsVCSpacingConstants.spacingBetweenAddButtonAndFaceIdToggle),
            faceIdView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: SettingsVCSpacingConstants.sideContentPadding),
            faceIdView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -SettingsVCSpacingConstants.sideContentPadding),
            faceIdView.heightAnchor.constraint(equalToConstant: SettingsVCSizeConstants.faceIdToggleHeight),

            faceIdIcon.leadingAnchor.constraint(equalTo: faceIdView.leadingAnchor),
            faceIdIcon.centerYAnchor.constraint(equalTo: faceIdView.centerYAnchor),
            faceIdIcon.widthAnchor.constraint(equalToConstant: SettingsVCSizeConstants.iconSize),
            faceIdIcon.heightAnchor.constraint(equalToConstant: SettingsVCSizeConstants.iconSize),

            faceIdLabel.leadingAnchor.constraint(equalTo: faceIdIcon.trailingAnchor, constant: SettingsVCSpacingConstants.spacingBetweenIconAndLabel),
            faceIdLabel.centerYAnchor.constraint(equalTo: faceIdView.centerYAnchor),

            faceIdSwitch.trailingAnchor.constraint(equalTo: faceIdView.trailingAnchor),
            faceIdSwitch.centerYAnchor.constraint(equalTo: faceIdView.centerYAnchor),

            faceIdView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }

    private func updateRemindersHeight() {
        let contentHeight = remindersTableView.contentSize.height
        let maxHeight = 4 * 64 + 3 * 12
        let height = min(contentHeight, CGFloat(maxHeight))

        if let existing = remindersContainerView.constraints.first(where: {
            $0.firstAttribute == .height
        }) {
            existing.constant = height
        } else {
            let heightConstraint = remindersContainerView.heightAnchor
                .constraint(equalToConstant: height)
            heightConstraint.priority = .required
            heightConstraint.isActive = true
        }

        view.layoutIfNeeded()
    }

}

// MARK: - Binding
extension SettingsViewController {
    private func bindViewModel() {
        viewModel.$avatar
            .sink { [weak self] avatar in
                self?.profileImageView.image = avatar?.image
            }
            .store(in: &cancellables)

        viewModel.$username
            .map { $0 as String? }
            .assign(to: \.text, on: userNameLabel)
            .store(in: &cancellables)

        viewModel.$isReminderEnabled
            .assign(to: \.isOn, on: reminderSwitch)
            .store(in: &cancellables)

        viewModel.$isBiometryEnabled
            .assign(to: \.isOn, on: faceIdSwitch)
            .store(in: &cancellables)

        viewModel.$biometryType
            .receive(on: RunLoop.main)
            .sink { [weak self] type in
                guard let self else { return }

                switch type {
                case .faceID:
                    faceIdIcon.image = AppIcons.settingsFaceId?.withRenderingMode(.alwaysTemplate)
                    faceIdLabel.text = LocalizedKey.settingsFaceIdSwitch

                case .touchID:
                    faceIdIcon.image = AppIcons.settingsTouchId?.withRenderingMode(.alwaysTemplate)
                    faceIdLabel.text = LocalizedKey.settingsTouchIdSwitch

                case .none:
                    faceIdView.isHidden = true
                }
            }
            .store(in: &cancellables)

        viewModel.$reminders
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.remindersTableView.reloadData()
                self?.updateRemindersHeight()
            }
            .store(in: &cancellables)

        viewModel.$reminderSheetPayload
            .sink { [weak self] payload in
                guard let self, let payload else { return }
                let picker = ReminderPickerViewController()
                switch payload {
                case .create:
                    picker.onSave = { [weak self] hour, minute in
                        self?.viewModel.handle(
                            .saveReminderTapped(hour, minute)
                        )
                    }
                case let .update(id, time):
                    picker.setInitialTime(from: time)
                    picker.onSave = { [weak self] hour, minute in
                        self?.viewModel.handle(
                            .updateReminder(id, hour, minute)
                        )
                    }
                }
                presentSheet(picker)
            }
            .store(in: &cancellables)

        viewModel.$error
            .compactMap { $0 }
            .sink { [weak self] error in
                self?.showError(error)
            }
            .store(in: &cancellables)

        viewModel.$isAvatarPickerPresented
            .filter { $0 }
            .sink { [weak self] _ in
                self?.presentAvatarPicker()
            }
            .store(in: &cancellables)
    }
}
