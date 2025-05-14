//
//  SaveNoteViewModel.swift
//  MindTracker
//
//  Created by Tark Wight on 23.02.2025.
//

import Foundation
import Combine

final class SaveNoteViewModel: ViewModel {
    weak var coordinator: SaveNoteCoordinatorProtocol?
    private let storageService: EmotionStorageServiceProtocol

    @Published private(set) var selectedActivityTags: [String] = []
    @Published private(set) var selectedPeopleTags: [String] = []
    @Published private(set) var selectedLocationTags: [String] = []

    var emotion: EmotionCard
 
    let activityLabel = LocalizedKey.saveNoteActivity
    let peopleLabel = LocalizedKey.saveNotePeople
    let locationLabel = LocalizedKey.saveNoteLocation
    let title = LocalizedKey.saveNoteTitle
    let saveButtonText = LocalizedKey.saveNoteSaveButton

    private var cancellables = Set<AnyCancellable>()

    init(
        coordinator: SaveNoteCoordinatorProtocol,
        emotionType: EmotionType,
        storageService: EmotionStorageServiceProtocol
    ) {
        self.coordinator = coordinator
        self.storageService = storageService
        self.emotion = EmotionCard(
            id: UUID(),
            type: emotionType,
            date: Date(),
            tags: EmotionTags(activity: [], people: [], location: [])
        )
    }

    func handle(_ event: Event) {
        switch event {
        case .saveNote:
            saveNote()
        case .dismiss:
            coordinator?.coordinatorDidFinish()
        case let .updateTags(type, tags):
            updateTags(type: type, tags: tags)
        }
    }
}

// MARK: - Private Methods

private extension SaveNoteViewModel {
    func updateTags(type: TagType, tags: [String]) {
        switch type {
        case .activity:
            selectedActivityTags = tags
        case .people:
            selectedPeopleTags = tags
        case .location:
            selectedLocationTags = tags
        }
    }

    func saveNote() {
        let updatedEmotion = EmotionCard(
            id: emotion.id,
            type: emotion.type,
            date: emotion.date,
            tags: EmotionTags(
                activity: selectedActivityTags.map { EmotionTag(id: UUID(), name: $0) },
                people: selectedPeopleTags.map { EmotionTag(id: UUID(), name: $0) },
                location: selectedLocationTags.map { EmotionTag(id: UUID(), name: $0) }
            )
        )

        Task {
            do {
                try await storageService.saveEmotion(updatedEmotion)
                coordinator?.saveNote()
            } catch {
                print("Ошибка сохранения эмоции: \(error)")
            }
        }
    }
}

// MARK: - Events

extension SaveNoteViewModel {
    enum Event {
        case saveNote
        case dismiss
        case updateTags(type: TagType, tags: [String])
    }

    enum TagType {
        case activity
        case people
        case location
    }
}
