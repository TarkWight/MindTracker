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

    @Published private(set) var avatar: Avatar? = nil
    @Published private(set) var username: String = LocalizedKey.settingsUserName
    @Published private(set) var reminders: [Reminder] = []
    @Published private(set) var isReminderEnabled: Bool = false
    @Published private(set) var isAvatarPickerPresented: Bool = false
    @Published private(set) var redinderId: UUID?
    @Published private(set) var error: SettingsViewModelError?
    @Published private(set) var reminderSheetPayload: ReminderSheetPayload?

    @Published private(set) var isBiometryEnabled: Bool = false
    @Published private(set) var biometryType: BiometryType = .none

    // MARK: - Services

    private let avatarService: AvatarServiceProtocol
    private let reminderService: ReminderServiceProtocol
    private let biometryService: BiometryServiceProtocol

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(
        coordinator: SettingsCoordinatorProtocol,
        avatarService: AvatarServiceProtocol,
        reminderService: ReminderServiceProtocol,
        biometryService: BiometryServiceProtocol
    ) {
        self.coordinator = coordinator
        self.avatarService = avatarService
        self.reminderService = reminderService
        self.biometryService = biometryService
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
                reminderSheetPayload = .update(
                    id: reminder.id,
                    time: reminder.time
                )
            }

        case .saveReminderTapped(let hours, let minutes):
            createReminder(hours, minutes)

        case .updateReminder(let id, let hours, let minutes):
            updateReminder(id, hours, minutes)

        case .deleteReminderTapped(let id):
            deleteReminder(id)

        case .biometrySwitcherTapped(let isOn):
            setBiometry(isOn)

        case .usernameChanged(let newName):
            username = newName
        }
    }

    // MARK: - Private

    private func loadData() {
        Task {
            await loadAvatar()
            await loadReminders()
            await loadBiometryState()
            await loadBiometryType()
        }
    }

    private func loadBiometryType() async {
        await MainActor.run {
            self.biometryType = self.biometryService.availableBiometryType()
        }
    }

    private func loadAvatar() async {
        do {
            if let data = try await avatarService.loadAvatar() {
                avatar = Avatar(data: data)
            } else {
                avatar = nil
            }
        } catch {
            avatar = nil
            self.error = .failedToLoadAvatar
        }

        if avatar == nil {
            avatar = Avatar(
                data: AppIcons.settingsProfilePlaceholder?.pngData()
            )
        }
    }

    private func loadReminders() async {
        do {
            let loaded = try await reminderService.fetchReminders()
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

    private func loadBiometryState() async {
        do {
            isBiometryEnabled = try await biometryService.isBiometryEnabled()
        } catch {
            isBiometryEnabled = false
            self.error = .failedToLoadBiometryState
        }
    }

    private func createReminder(_ hours: Int, _ minutes: Int) {
        let calendar = Calendar.current
        let now = Date()
        let date =
            calendar.date(
                bySettingHour: hours,
                minute: minutes,
                second: 0,
                of: now
            ) ?? now

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
        let date =
            calendar.date(
                bySettingHour: hours,
                minute: minutes,
                second: 0,
                of: now
            ) ?? now

        Task {
            guard var reminder = reminders.first(where: { $0.id == id }) else {
                return
            }
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
            guard let reminder = reminders.first(where: { $0.id == id }) else {
                return
            }
            do {
                try await reminderService.deleteReminder(by: reminder.id)
                await loadReminders()
            } catch {
                self.error = .failedToDeleteReminder
            }
        }
    }

    private func saveAvatar(_ data: Data) {
        Task {
            if data.isEmpty {
                try? await avatarService.deleteAvatar()
                avatar = Avatar(
                    data: AppIcons.settingsProfilePlaceholder?.pngData()
                )
                return
            }

            let newAvatar = Avatar(data: data)
            do {
                if avatar == nil {
                    try await avatarService.saveAvatar(newAvatar)
                } else {
                    try await avatarService.updateAvatar(newAvatar)
                }
                avatar = newAvatar
            } catch {
                self.error =
                    avatar == nil ? .failedToSaveAvatar : .failedToUpdateAvatar
            }
        }
    }

    private func setBiometry(_ isOn: Bool) {
        Task {
            let available = biometryService.availableBiometryType()
            guard available != .none else {
                await MainActor.run {
                    self.isBiometryEnabled = false
                    self.error = .biometryUnavailable
                }
                return
            }

            do {
                try await biometryService.setBiometryEnabled(isOn)
                await MainActor.run {
                    self.isBiometryEnabled = isOn
                }
            } catch let error as AuthError {
                await MainActor.run {
                    self.isBiometryEnabled = false
                    switch error {
                    case .biometryNotEnrolled:
                        self.error = .biometryNotEnrolled
                    case .biometryLockout:
                        self.error = .biometryLockedOut
                    case .biometryFailed:
                        self.error = .biometryFailed
                    case .biometryUnavailable:
                        self.error = .biometryUnavailable
                    }
                }
            } catch {
                await MainActor.run {
                    self.isBiometryEnabled = false
                    self.error = .failedToSetBiometry
                }
            }
        }
    }
    // MARK: - Event

    enum Event {
        case viewDidLoad

        case avatarTapped
        case avatarChanged(Data)

        case remindSwitcherTapped(Bool)
        case addReminderTapped
        case saveReminderTapped(Int, Int)
        case remindTapped(UUID)
        case updateReminder(UUID, Int, Int)
        case deleteReminderTapped(UUID)

        case biometrySwitcherTapped(Bool)
        case usernameChanged(String)
    }
}
