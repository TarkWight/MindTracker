//
//  SettingsViewModel.swift
//  MindTracker
//
//  Created by Tark Wight on 24.02.2025.
//

import Combine
import UIKit

final class SettingsViewModel: ViewModel {

    // MARK: - Coordinator

    weak var coordinator: SettingsCoordinatorProtocol?

    // MARK: - Published Properties

    @Published private(set) var avatar: Avatar?
    @Published private(set) var username: String
    @Published private(set) var reminders: [Reminder]
    @Published private(set) var isReminderEnabled: Bool
    @Published private(set) var isFaceIDEnabled: Bool
    @Published private(set) var editingReminderID: UUID?
    @Published private(set) var isAvatarPickerPresented: Bool = false
    @Published private(set) var error: SettingsViewModelError?

    // MARK: - Static UI

    let title: String = LocalizedKey.settingsViewTitle
    let reminderIcon = AppIcons.settingsReminders
    let reminderLabel: String = LocalizedKey.settingsReminderSwitch
    let deleteReminderIcon = AppIcons.settingsDelete
    let addReminderButtonLabel = LocalizedKey.settingsAddReminderButton
    let faceIdIcon = AppIcons.settingsFaceId
    let faceIdLabel = LocalizedKey.settingsFaceIdSwitch

    // MARK: - Services

    private let avatarService: AvatarServiceProtocol
    private let reminderService: ReminderServiceProtocol
    private let faceIDService: FaceIDServiceProtocol

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(
        coordinator: SettingsCoordinatorProtocol,
        avatarService: AvatarServiceProtocol,
        reminderService: ReminderServiceProtocol,
        faceIDService: FaceIDServiceProtocol
    ) {
        self.coordinator = coordinator
        self.avatarService = avatarService
        self.reminderService = reminderService
        self.faceIDService = faceIDService

        self.avatar = nil
        self.username = LocalizedKey.settingsUserName
        self.reminders = []
        self.isReminderEnabled = true
        self.isFaceIDEnabled = false
    }

    // MARK: - Event Handling

    func handle(_ event: Event) {
        switch event {
        case .viewDidLoad:
            loadData()

        case .avatarTapped:
            isAvatarPickerPresented = true

        case .avatarChanged(let data):
            saveAvatar(data)

        case .remindSwitcherTapped(let isOn):
            isReminderEnabled = isOn

        case .faceIdSwitcherTapped(let isOn):
            setFaceID(isOn)

        case .remindTapper(let id):
            editingReminderID = id

        case .usernameChanged(let newName):
            username = newName

        case .toggleReminder(let isOn):
            isReminderEnabled = isOn

        case .updateReminderTime(let id):
            editingReminderID = id

        case .toggleFaceID(let isOn):
            setFaceID(isOn)

        case .addReminderTapped:
            editingReminderID = nil

        case .deleteReminderTapped(let id):
            deleteReminder(id)

        case .saveReminderTapped(let id):
            saveReminder(id)
        }
    }

    // MARK: - Private

    private func loadData() {
        Task {
            await loadAvatar()
            await loadReminders()
            await loadFaceIDState()
        }
    }

    private func loadAvatar() async {
//        do {
//            if let data = try await avatarService.loadAvatar() {
//                avatar = Avatar(data: data)
//            } else {
                avatar = Avatar(data: AppIcons.settingsProfilePlaceholder?.pngData())
//            }
//        } catch {
//            avatar = Avatar(data: AppIcons.settingsProfilePlaceholder?.pngData())
//            self.error = .failedToLoadAvatar
//        }
    }

    private func saveAvatar(_ data: Data) {
        Task {
            let newAvatar = Avatar(data: data)
            do {
                if avatar == nil {
                    try await avatarService.saveAvatar(newAvatar)
                } else {
                    try await avatarService.updateAvatar(newAvatar)
                }
                avatar = newAvatar
            } catch {
                self.error = avatar == nil ? .failedToSaveAvatar : .failedToUpdateAvatar
            }
        }
    }

    private func loadReminders() async {
        do {
            reminders = try await reminderService.loadReminders()
        } catch {
            reminders = []
            self.error = .failedToLoadReminders
        }
    }

    private func deleteReminder(_ id: UUID) {
        Task {
            guard let reminder = reminders.first(where: { $0.id == id }) else { return }
            do {
                try await reminderService.deleteReminder(reminder)
                await loadReminders()
            } catch {
                self.error = .failedToDeleteReminder
            }
        }
    }

    private func saveReminder(_ id: UUID) {
        Task {
            guard let reminder = reminders.first(where: { $0.id == id }) else { return }
            do {
                try await reminderService.updateReminder(reminder)
                await loadReminders()
            } catch {
                self.error = .failedToUpdateReminder
            }
        }
    }

    private func loadFaceIDState() async {
        do {
            isFaceIDEnabled = try await faceIDService.isFaceIDEnabled()
        } catch {
            isFaceIDEnabled = false
            self.error = .failedToSetFaceID
        }
    }

    private func setFaceID(_ isOn: Bool) {
        Task {
            do {
                try await faceIDService.setFaceIDEnabled(isOn)
                isFaceIDEnabled = isOn
            } catch {
                self.error = .failedToSetFaceID
            }
        }
    }

    // MARK: - Event

    enum Event {
        case viewDidLoad
        case avatarTapped
        case avatarChanged(Data)
        case remindSwitcherTapped(Bool)
        case faceIdSwitcherTapped(Bool)
        case remindTapper(UUID)
        case usernameChanged(String)
        case toggleReminder(Bool)
        case updateReminderTime(UUID)
        case toggleFaceID(Bool)
        case addReminderTapped
        case deleteReminderTapped(UUID)
        case saveReminderTapped(UUID)
    }
}

enum SettingsViewModelError: Error {
    case failedToLoadAvatar
    case failedToSaveAvatar
    case failedToUpdateAvatar
    case failedToDeleteAvatar
    case failedToLoadReminders
    case failedToSaveReminder
    case failedToDeleteReminder
    case failedToUpdateReminder
    case failedToSetFaceID
}

extension SettingsViewModelError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .failedToLoadAvatar:
            return "Не удалось загрузить аватар."
        case .failedToSaveAvatar:
            return "Не удалось сохранить аватар."
        case .failedToUpdateAvatar:
            return "Не удалось обновить аватар."
        case .failedToDeleteAvatar:
            return "Не удалось удалить аватар."
        case .failedToLoadReminders:
            return "Не удалось загрузить напоминания."
        case .failedToSaveReminder:
            return "Не удалось сохранить напоминание."
        case .failedToDeleteReminder:
            return "Не удалось удалить напоминание."
        case .failedToUpdateReminder:
            return "Не удалось обновить напоминание."
        case .failedToSetFaceID:
            return "Не удалось включить или выключить Face ID."
        }
    }
}
