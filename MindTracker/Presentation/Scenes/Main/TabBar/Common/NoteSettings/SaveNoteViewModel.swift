//
//  SaveNoteViewModel.swift
//  MindTracker
//
//  Created by Tark Wight on 23.02.2025.
//

import Foundation

final class SaveNoteViewModel: ViewModel {
    weak var coordinator: SaveNoteCoordinatorProtocol?

    private var emotion: EmotionCardModel

    let activityLabel: String = LocalizedKey.saveNoteActivity
    let peopleLabel: String = LocalizedKey.saveNotePeople
    let locationLabel: String = LocalizedKey.saveNoteLocation
    let title: String = LocalizedKey.saveNoteTitle
    let saveButtonText: String = LocalizedKey.saveNoteSaveButton

    var selectedActivityTags: [String]
    var selectedPeopleTags: [String]
    var selectedLocationTags: [String]

    var onDataUpdated: (([String], [String], [String]) -> Void)?

    init(coordinator: SaveNoteCoordinatorProtocol) {
        self.coordinator = coordinator
        self.emotion = Self.getRandomEmotion()

        self.selectedActivityTags = MockTagsData.activityTags
        self.selectedPeopleTags = MockTagsData.peopleTags
        self.selectedLocationTags = MockTagsData.locationTags
    }

    func getEmotionMock() -> EmotionCardModel {
        return emotion
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

    private func saveNote() {
        coordinator?.saveNote()
    }

    private func updateTags(type: TagType, tags: [String]) {
        switch type {
        case .activity:
            selectedActivityTags = tags
        case .people:
            selectedPeopleTags = tags
        case .location:
            selectedLocationTags = tags
        }
        onDataUpdated?(selectedActivityTags, selectedPeopleTags, selectedLocationTags)
    }

    private static func getRandomEmotion() -> EmotionCardModel {
        let randomEmotion = MockEmotionsData.getMockData(for: .five).randomElement()
        ?? EmotionCardModel(type: .calmness, date: Date())
        return EmotionCardModel(type: randomEmotion.type, date: randomEmotion.date)
    }
}

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
