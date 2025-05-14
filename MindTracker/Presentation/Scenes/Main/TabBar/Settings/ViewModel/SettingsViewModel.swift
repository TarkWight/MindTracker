//
//  SettingsViewModel.swift
//  MindTracker
//
//  Created by Tark Wight on 24.02.2025.
//

import Combine
import Foundation

final class SettingsViewModel: ViewModel {

    // MARK: - Coordinator

    weak var coordinator: SettingsCoordinatorProtocol?

    // MARK: - Published Properties

    @Published private(set) var avatar: Avatar?
    @Published private(set) var username: String
    @Published private(set) var reminders: [Reminder]
    @Published private(set) var isReminderEnabled: Bool
    @Published private(set) var isFaceIDEnabled: Bool
    @Published private(set) var isAvatarPickerPresented: Bool = false
    @Published private(set) var redinderId: UUID?
    @Published private(set) var error: SettingsViewModelError?
    @Published var reminderSheetPayload: ReminderSheetPayload?

    // MARK: - Private Properties

    private var hasAvatar: Bool {
        avatar == nil
    }

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

        case .addReminderTapped:
            reminderSheetPayload = .create

        case .remindTapped(let id):
            if let reminder = reminders.first(where: { $0.id == id }) {
                reminderSheetPayload = .update(id: reminder.id, time: reminder.time)
            }

        case .saveReminderTapped(let hours, let minutes):
            createReminder(hours, minutes)

        case .updateReminder(let id, let hours, let minutes):
            updateReminder(id, hours, minutes)

        case .deleteReminderTapped(let id):
            deleteReminder(id)

        case .faceIdSwitcherTapped(let isOn):
            setFaceID(isOn)

        case .usernameChanged(let newName):
            username = newName
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
        if hasAvatar {
            avatar = Avatar(data: AppIcons.settingsProfilePlaceholder?.pngData())
            return
        }

        do {
            if let data = try await avatarService.loadAvatar() {
                avatar = Avatar(data: data)
            } else {
                avatar = Avatar(data: AppIcons.settingsProfilePlaceholder?.pngData())
            }
        } catch {
            avatar = Avatar(data: AppIcons.settingsProfilePlaceholder?.pngData())
            self.error = .failedToLoadAvatar
        }
    }

    private func loadReminders() async {
        do {
            let loaded = try await reminderService.loadReminders()
            await MainActor.run {
                self.reminders = loaded
            }
        } catch {
            await MainActor.run {
                self.reminders = []
                self.error = .failedToLoadReminders
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

    private func createReminder(_ hours: Int, _ minutes: Int) {
        let calendar = Calendar.current
        let now = Date()
        let date = calendar.date(bySettingHour: hours, minute: minutes, second: 0, of: now) ?? now

        Task {
            let reminder = Reminder(id: .init(), time: date)
            do {
                try await reminderService.createReminder(reminder)
                await loadReminders()
            } catch {
                self.error = .failedToCreateReminder
            }
        }
    }

    private func updateReminder(_ id: UUID, _ hours: Int, _ minutes: Int) {
        let calendar = Calendar.current
        let now = Date()
        let date = calendar.date(bySettingHour: hours, minute: minutes, second: 0, of: now) ?? now

        Task {
            guard var reminder = reminders.first(where: { $0.id == id }) else { return }
            reminder.time = date
            do {
                try await reminderService.updateReminder(reminder)
                await loadReminders()
            } catch {
                self.error = .failedToUpdateReminder
            }
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
        /// vc load
        case viewDidLoad
        /// avatar
        case avatarTapped
        case avatarChanged(Data)
        /// reminders
        case remindSwitcherTapped(Bool)
        case addReminderTapped
        case saveReminderTapped(Int, Int)
        case remindTapped(UUID)
        case updateReminder(UUID, Int, Int)
        case deleteReminderTapped(UUID)
        /// faceId
        case faceIdSwitcherTapped(Bool)
        case usernameChanged(String)
    }
}
