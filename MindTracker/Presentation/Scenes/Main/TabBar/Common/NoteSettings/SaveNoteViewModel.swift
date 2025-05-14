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
    private let emotuinStorageService: EmotionStorageServiceProtocol
    private let tagStorageService: TagStorageServiceProtocol

    @Published private(set) var selectedActivityTags: [String] = []
    @Published private(set) var selectedPeopleTags: [String] = []
    @Published private(set) var selectedLocationTags: [String] = []
    @Published var allTags: EmotionTags = .init(activity: [], people: [], location: [])

    var emotion: EmotionCard

    let activityLabel = LocalizedKey.saveNoteActivity
    let peopleLabel = LocalizedKey.saveNotePeople
    let locationLabel = LocalizedKey.saveNoteLocation
    let title = LocalizedKey.saveNoteTitle
    let saveButtonText = LocalizedKey.saveNoteSaveButton

    private var cancellables = Set<AnyCancellable>()

    init(
        coordinator: SaveNoteCoordinatorProtocol,
        emotion: EmotionCard,
        storageService: EmotionStorageServiceProtocol,
        tagStorageService: TagStorageServiceProtocol
    ) {
        self.coordinator = coordinator
        self.emotuinStorageService = storageService
        self.emotion = emotion
        self.tagStorageService = tagStorageService
    }

    func handle(_ event: Event) {
        switch event {
        case .viewDidLoad:
            fetchTags()
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

    func fetchTags() {
        Task {
            do {
                try await tagStorageService.seedDefaultTagsIfNeeded()
                let tags = try await tagStorageService.fetchAllTags()
                allTags = tags
                selectedActivityTags = tags.activity.map { $0.name }
                selectedPeopleTags = tags.people.map { $0.name }
                selectedLocationTags = tags.location.map { $0.name }
            } catch {
                print("Ошибка получения тегов: \(error)")
            }
        }
    }

    func saveNote() {
        let updatedEmotion = EmotionCard(
            id: emotion.id,
            type: emotion.type,
            date: emotion.date,
            tags: EmotionTags(
                activity: selectedActivityTags.map {
                    EmotionTag(id: UUID(), name: $0, tagTypeRaw: TagType.activity.rawValue)
                },
                people: selectedPeopleTags.map {
                    EmotionTag(id: UUID(), name: $0, tagTypeRaw: TagType.people.rawValue)
                },
                location: selectedLocationTags.map {
                    EmotionTag(id: UUID(), name: $0, tagTypeRaw: TagType.location.rawValue)
                }
            )
        )

        Task {
            do {
                let exists = try await emotuinStorageService.containsEmotion(withId: updatedEmotion.id)
                if exists {
                    try await emotuinStorageService.updateEmotion(updatedEmotion)
                    EmotionEventBus.shared.emotionPublisher.send(.updated(updatedEmotion))
                } else {
                    try await emotuinStorageService.saveEmotion(updatedEmotion)
                    EmotionEventBus.shared.emotionPublisher.send(.added(updatedEmotion))
                }

                coordinator?.saveNote()
            } catch {
                print("Ошибка сохранения эмоции: \(error)")
            }
        }
    }

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
}

// MARK: - Events

extension SaveNoteViewModel {
    enum Event {
        case viewDidLoad
        case saveNote
        case dismiss
        case updateTags(type: TagType, tags: [String])
    }
}
