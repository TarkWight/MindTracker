//
//  SettingsViewController.swift
//  MindTracker
//
//  Created by Tark Wight on 24.02.2025.
//

import UIKit
import Combine

final class SettingsViewController: UIViewController {

    // MARK: - Properties

    let viewModel: SettingsViewModel
    private var cancellables = Set<AnyCancellable>()

    // MARK: - UI Components
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

    // MARK: - Init

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SettingsVCStyleConstants.backgroundColor

        setupUI()
        viewModel.handle(.viewDidLoad)
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Setup

    private func setupUI() {
        setupTitle()
        setupProfileData()
        setupReminderBlock()
        setupRemindersContainerView()
        setupFaceIdBlock()
        setupConstraints()
    }

    private func setupTitle() {
        titleLabel.text = viewModel.title
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
        reminderIcon.image = viewModel.reminderIcon
        reminderIcon.contentMode = .scaleAspectFit
        reminderIcon.image?.withRenderingMode(.alwaysTemplate)
        reminderIcon.tintColor = AppColors.appWhite

        reminderLabel.text = viewModel.reminderLabel
        reminderLabel.font = SettingsVCStyleConstants.reminderFont
        reminderLabel.textColor = SettingsVCStyleConstants.textColor

        reminderView.addSubview(reminderIcon)
        reminderView.addSubview(reminderLabel)
        reminderView.addSubview(reminderSwitch)

        reminderSwitch.addTarget(self, action: #selector(reminderSwitchChanged(_:)), for: .valueChanged)

        let addReminderButtonConfig = ButtonConfiguration(
            title: viewModel.addReminderButtonLabel,
            textColor: .black,
            font: .systemFont(ofSize: 16, weight: .medium),
            fontSize: 16,
            icon: nil,
            iconSize: 0,
            backgroundColor: .white,
            buttonHeight: SettingsVCSizeConstants.addButtonHeight,
            cornerRadius: SettingsVCSizeConstants.addButtonHeight / 2,
            padding: 16,
            iconPosition: .left
        )
        addReminderButton.configure(with: addReminderButtonConfig)
        addReminderButton.addTarget(self, action: #selector(addRemindButtonTapped), for: .touchUpInside)
    }

    private func setupRemindersContainerView() {
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

    private func setupFaceIdBlock() {
        faceIdIcon.image = viewModel.faceIdIcon
        faceIdIcon.contentMode = .scaleAspectFill
        faceIdIcon.image = viewModel.faceIdIcon?.withRenderingMode(.alwaysTemplate)
        faceIdIcon.tintColor = AppColors.appWhite
        faceIdLabel.text = viewModel.faceIdLabel
        faceIdLabel.font = SettingsVCStyleConstants.faceIdFont
        faceIdLabel.textColor = SettingsVCStyleConstants.textColor

        faceIdView.addSubview(faceIdIcon)
        faceIdView.addSubview(faceIdLabel)
        faceIdView.addSubview(faceIdSwitch)

        faceIdSwitch.addTarget(self, action: #selector(faceIDSwitchChanged(_:)), for: .valueChanged)
    }

    private func setupConstraints() {
        [
            titleLabel,
            profileImageView,
            userNameLabel,
            reminderView,
            reminderIcon,
            reminderLabel,
            reminderSwitch,
            remindersContainerView,
            addReminderButton,
            faceIdView,
            faceIdIcon,
            faceIdLabel,
            faceIdSwitch,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SettingsVCSpacingConstants.sideContentPadding),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SettingsVCSpacingConstants.sideContentPadding),
            titleLabel.heightAnchor.constraint(equalToConstant: SettingsVCSizeConstants.labelSize),

            profileImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: SettingsVCSpacingConstants.spacingBetweenLabelAndAvatar),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: SettingsVCSizeConstants.avatarSize),
            profileImageView.heightAnchor.constraint(equalToConstant: SettingsVCSizeConstants.avatarSize),

            userNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: SettingsVCSpacingConstants.spacingBetweenAvatarAndName),
            userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            reminderView.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: SettingsVCSpacingConstants.spacingBetweenNameAndRemindToggle),
            reminderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SettingsVCSpacingConstants.sideContentPadding),
            reminderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SettingsVCSpacingConstants.sideContentPadding),
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
            remindersContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SettingsVCSpacingConstants.sideContentPadding),
            remindersContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SettingsVCSpacingConstants.sideContentPadding),

            remindersTableView.topAnchor.constraint(equalTo: remindersContainerView.topAnchor),
            remindersTableView.bottomAnchor.constraint(equalTo: remindersContainerView.bottomAnchor),
            remindersTableView.leadingAnchor.constraint(equalTo: remindersContainerView.leadingAnchor),
            remindersTableView.trailingAnchor.constraint(equalTo: remindersContainerView.trailingAnchor),

            remindersContainerView.bottomAnchor.constraint(lessThanOrEqualTo: remindersTableView.bottomAnchor, constant: 0).withPriority(.defaultLow),

            addReminderButton.topAnchor.constraint(equalTo: remindersContainerView.bottomAnchor, constant: SettingsVCSpacingConstants.spacingBetweenTableAndAddButton),
            addReminderButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SettingsVCSpacingConstants.sideContentPadding),
            addReminderButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SettingsVCSpacingConstants.sideContentPadding),

            faceIdView.topAnchor.constraint(equalTo: addReminderButton.bottomAnchor, constant: SettingsVCSpacingConstants.spacingBetweenAddButtonAndFaceIdToggle),
            faceIdView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SettingsVCSpacingConstants.sideContentPadding),
            faceIdView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SettingsVCSpacingConstants.sideContentPadding),
            faceIdView.heightAnchor.constraint(equalToConstant: SettingsVCSizeConstants.faceIdToggleHeight),

            faceIdIcon.leadingAnchor.constraint(equalTo: faceIdView.leadingAnchor),
            faceIdIcon.centerYAnchor.constraint(equalTo: faceIdView.centerYAnchor),
            faceIdIcon.widthAnchor.constraint(equalToConstant: SettingsVCSizeConstants.iconSize),
            faceIdIcon.heightAnchor.constraint(equalToConstant: SettingsVCSizeConstants.iconSize),

            faceIdLabel.leadingAnchor.constraint(equalTo: faceIdIcon.trailingAnchor, constant: SettingsVCSpacingConstants.spacingBetweenIconAndLabel),
            faceIdLabel.centerYAnchor.constraint(equalTo: faceIdView.centerYAnchor),

            faceIdSwitch.trailingAnchor.constraint(equalTo: faceIdView.trailingAnchor),
            faceIdSwitch.centerYAnchor.constraint(equalTo: faceIdView.centerYAnchor),
        ])
    }

    deinit {
        ConsoleLogger.classDeInitialized()
    }
}

// MARK: - Binding

private extension SettingsViewController {
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

        viewModel.$isFaceIDEnabled
            .assign(to: \.isOn, on: faceIdSwitch)
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
                        self?.viewModel.handle(.saveReminderTapped(hour, minute))
                    }

                case let .update(id, time):
                    picker.setInitialTime(from: time)
                    picker.onSave = { [weak self] hour, minute in
                        self?.viewModel.handle(.updateReminder(id, hour, minute))
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
    }
}

// MARK: - Private Methods

private extension SettingsViewController {

    func updateRemindersHeight() {
        let contentHeight = remindersTableView.contentSize.height
        let maxHeight = 4 * 64 + 3 * 12
        let height = min(contentHeight, CGFloat(maxHeight))

        if let existing = remindersContainerView.constraints.first(where: { $0.firstAttribute == .height }) {
            existing.constant = height
        } else {
            let heightConstraint = remindersContainerView.heightAnchor.constraint(equalToConstant: height)
            heightConstraint.priority = .required
            heightConstraint.isActive = true
        }

        view.layoutIfNeeded()
    }

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

// MARK: - Actions

private extension SettingsViewController {

    @objc func avatarTapped() {
        viewModel.handle(.avatarTapped)
    }

    @objc func reminderSwitchChanged(_ sender: UISwitch) {
        viewModel.handle(.remindSwitcherTapped(sender.isOn))
    }

    @objc func faceIDSwitchChanged(_ sender: UISwitch) {
        viewModel.handle(.faceIdSwitcherTapped(sender.isOn))
    }

    @objc func addRemindButtonTapped() {
        self.viewModel.handle(.addReminderTapped)
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.reminders.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let spacer = UIView()
        spacer.backgroundColor = .clear
        return spacer
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderCell.reuseIdentifier, for: indexPath) as? ReminderCell else {
            return UITableViewCell()
        }

        let reminder = viewModel.reminders[indexPath.section]
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let label = formatter.string(from: reminder.time)

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
