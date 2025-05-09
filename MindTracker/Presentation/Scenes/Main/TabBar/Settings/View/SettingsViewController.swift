//
//  SettingsViewController.swift
//  MindTracker
//
//  Created by Tark Wight on 24.02.2025.
//

import UIKit
import Combine

// TODO: - обернуть в ScrollView
final class SettingsViewController: UIViewController {

    // MARK: - Properties

    let viewModel: SettingsViewModel
    private var cancellables = Set<AnyCancellable>()

    // MARK: - UI Components

    let titleLabel = UILabel()
    private let profileImageView = UIImageView()
    private let userNameLabel = UILabel()
    private let reminderView = UIView()
    private let reminderIcon = UIImageView()
    private let reminderLabel = UILabel()
    private let reminderSwitch = UISwitch()
    private let reminderTimeButton = CustomButton()
    private let addReminderButton = CustomButton()
    private let faceIdView = UIView()
    private let faceIdIcon = UIImageView()
    private let faceIdLabel = UILabel()
    private let faceIdSwitch = UISwitch()
    private let timePicker = UIDatePicker()

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
        view.backgroundColor = Constants.Style.backgroundColor

        setupTitle()
        setupUI()
        setupConstraints()
        setupTimePicker()
        bindViewModel()

        viewModel.handle(.viewDidLoad)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Setup

    private func setupTitle() {
        titleLabel.text = viewModel.title
        titleLabel.font = Constants.Style.titleFont
        titleLabel.textColor = Constants.Style.textColor
        titleLabel.sizeToFit()
    }

    private func setupUI() {
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = Constants.Layout.profileImageSize / 2
        profileImageView.clipsToBounds = true
        profileImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        profileImageView.addGestureRecognizer(tapGesture)

        userNameLabel.font = Constants.Style.userNameFont
        userNameLabel.textColor = Constants.Style.textColor
        userNameLabel.textAlignment = .center

        reminderIcon.image = viewModel.reminderIcon
        reminderIcon.contentMode = .scaleAspectFit
        reminderIcon.image?.withRenderingMode(.alwaysTemplate)
        reminderIcon.tintColor = AppColors.appWhite

        reminderLabel.text = viewModel.reminderLabel
        reminderLabel.font = Constants.Style.reminderFont
        reminderLabel.textColor = Constants.Style.textColor

        reminderView.addSubview(reminderIcon)
        reminderView.addSubview(reminderLabel)
        reminderView.addSubview(reminderSwitch)

        reminderSwitch.addTarget(self, action: #selector(reminderSwitchChanged(_:)), for: .valueChanged)

        let reminderButtonConfig = ButtonConfiguration(
            title: "",
            textColor: AppColors.appWhite,
            font: Typography.body,
            fontSize: 16,
            icon: viewModel.deleteReminderIcon,
            iconSize: 48,
            backgroundColor: AppColors.appGray,
            buttonHeight: Constants.Layout.reminderButtonHeight,
            cornerRadius: Constants.Layout.buttonCornerRadius,
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
            buttonHeight: Constants.Layout.addButtonHeight,
            cornerRadius: Constants.Layout.buttonCornerRadius,
            padding: 16,
            iconPosition: .left
        )
        addReminderButton.configure(with: addReminderButtonConfig)

        faceIdIcon.image = viewModel.faceIdIcon
        faceIdIcon.contentMode = .scaleAspectFill
        faceIdIcon.image?.withRenderingMode(.alwaysTemplate)
        faceIdIcon.tintColor = AppColors.appWhite

        faceIdLabel.text = viewModel.faceIdLabel
        faceIdLabel.font = Constants.Style.faceIdFont
        faceIdLabel.textColor = Constants.Style.textColor

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
            reminderTimeButton,
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
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Layout.sidePadding),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Layout.sidePadding),
            titleLabel.heightAnchor.constraint(equalToConstant: 44),

            profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.Layout.topPadding),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: Constants.Layout.profileImageSize),
            profileImageView.heightAnchor.constraint(equalToConstant: Constants.Layout.profileImageSize),

            userNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: Constants.Layout.profileSpacing),
            userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            reminderView.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: Constants.Layout.blockSpacing),
            reminderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Layout.sidePadding),
            reminderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Layout.sidePadding),
            reminderView.heightAnchor.constraint(equalToConstant: Constants.Layout.reminderButtonHeight),

            reminderIcon.leadingAnchor.constraint(equalTo: reminderView.leadingAnchor),
            reminderIcon.centerYAnchor.constraint(equalTo: reminderView.centerYAnchor),
            reminderIcon.widthAnchor.constraint(equalToConstant: Constants.Layout.iconSize),
            reminderIcon.heightAnchor.constraint(equalToConstant: Constants.Layout.iconSize),

            reminderLabel.leadingAnchor.constraint(equalTo: reminderIcon.trailingAnchor, constant: Constants.Layout.iconTextSpacing),
            reminderLabel.centerYAnchor.constraint(equalTo: reminderView.centerYAnchor),

            reminderSwitch.trailingAnchor.constraint(equalTo: reminderView.trailingAnchor),
            reminderSwitch.centerYAnchor.constraint(equalTo: reminderView.centerYAnchor),

            reminderTimeButton.topAnchor.constraint(equalTo: reminderView.bottomAnchor, constant: Constants.Layout.blockSpacing),
            reminderTimeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Layout.sidePadding),
            reminderTimeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Layout.sidePadding),

            addReminderButton.topAnchor.constraint(equalTo: reminderTimeButton.bottomAnchor, constant: Constants.Layout.buttonSpacing),
            addReminderButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Layout.sidePadding),
            addReminderButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Layout.sidePadding),

            faceIdView.topAnchor.constraint(equalTo: addReminderButton.bottomAnchor, constant: Constants.Layout.blockSpacing),
            faceIdView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Layout.sidePadding),
            faceIdView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Layout.sidePadding),
            faceIdView.heightAnchor.constraint(equalToConstant: Constants.Layout.reminderButtonHeight),

            faceIdIcon.leadingAnchor.constraint(equalTo: faceIdView.leadingAnchor),
            faceIdIcon.centerYAnchor.constraint(equalTo: faceIdView.centerYAnchor),
            faceIdIcon.widthAnchor.constraint(equalToConstant: Constants.Layout.iconSize),
            faceIdIcon.heightAnchor.constraint(equalToConstant: Constants.Layout.iconSize),

            faceIdLabel.leadingAnchor.constraint(equalTo: faceIdIcon.trailingAnchor, constant: Constants.Layout.iconTextSpacing),
            faceIdLabel.centerYAnchor.constraint(equalTo: faceIdView.centerYAnchor),

            faceIdSwitch.trailingAnchor.constraint(equalTo: faceIdView.trailingAnchor),
            faceIdSwitch.centerYAnchor.constraint(equalTo: faceIdView.centerYAnchor),
        ])
    }

    private func setupTimePicker() {
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.tintColor = AppColors.appGray
    }

    // MARK: - Binding

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

        viewModel.$error
            .compactMap { $0 }
            .sink { [weak self] error in
                self?.showError(error)
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions

    @objc private func avatarTapped() {
        viewModel.handle(.avatarTapped)
    }

    @objc private func reminderSwitchChanged(_ sender: UISwitch) {
        viewModel.handle(.remindSwitcherTapped(sender.isOn))
    }

    @objc private func faceIDSwitchChanged(_ sender: UISwitch) {
        viewModel.handle(.faceIdSwitcherTapped(sender.isOn))
    }

    @objc private func showTimePicker() {
        let pickerVC = ReminderPickerViewController()

        pickerVC.onSave = { [weak self] hour, minute in
            guard let self else { return }

            let calendar = Calendar.current
            let now = Date()
            let date = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: now) ?? now

            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            self.reminderTimeButton.setTitle(formatter.string(from: date), for: .normal)
        }

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

    private func showError(_ error: SettingsViewModelError) {
        let alert = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }

    deinit {
        ConsoleLogger.classDeInitialized()
    }
}

extension SettingsViewController {
    enum Constants {
        enum Layout {
            static let topPadding: CGFloat = 152
            static let sidePadding: CGFloat = 24
            static let profileImageSize: CGFloat = 96
            static let profileSpacing: CGFloat = 12
            static let blockSpacing: CGFloat = 32
            static let iconSize: CGFloat = 24
            static let iconTextSpacing: CGFloat = 8
            static let reminderButtonHeight: CGFloat = 64
            static let deleteButtonSize: CGFloat = 48
            static let buttonSpacing: CGFloat = 16
            static let addButtonHeight: CGFloat = 64
            static let buttonCornerRadius: CGFloat = 28
        }
        enum Style {
            static let backgroundColor = AppColors.background
            static let textColor = AppColors.appWhite
            static let userNameFont = Typography.header3
            static let userNameColor = AppColors.appWhite
            static let reminderFont = Typography.body
            static let faceIdFont = Typography.body
            static  let titleFont = Typography.header1
        }
    }
}
