//
//  SaveNoteViewModel.swift
//  MindTracker
//
//  Created by Tark Wight on 23.02.2025.
//

import Foundation
import UIKit

final class SaveNoteViewModel: ViewModel {
    weak var coordinator: SaveNoteCoordinatorProtocol?

    private var emotion: EmotionCardModel

    let labelsFont = UITheme.Font.SaveNote.label
    let labelsColor = UITheme.Colors.appWhite
    let activityLabel: String = LocalizedKey.SaveNote.activity
    let peopleLabel: String = LocalizedKey.SaveNote.people
    let locationLabel: String = LocalizedKey.SaveNote.location
    var selectedActivityTags: [String]
    var selectedPeopleTags: [String]
    var selectedLocationTags: [String]

    var onDataUpdated: (([String], [String], [String]) -> Void)?

    var title: String { LocalizedKey.SaveNote.title }
    var titleFont: UIFont { UITheme.Font.SaveNote.title }
    var titleColor: UIColor { UITheme.Colors.appWhite }

    var saveButtonText: String { LocalizedKey.SaveNote.saveButton }
    var saveButtonColor: UIColor { UITheme.Colors.appWhite }
    var saveButtonTextColor: UIColor { .black }
    var saveButtonFont: UIFont { UITheme.Font.SaveNote.saveButton }
    var saveButtonCornerRadius: CGFloat { 20 }

    init(coordinator: SaveNoteCoordinatorProtocol) {
        self.coordinator = coordinator
        emotion = Self.getRandomEmotion()

        selectedActivityTags = MockTagsData.activityTags
        selectedPeopleTags = MockTagsData.peopleTags
        selectedLocationTags = MockTagsData.locationTags
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
        let randomEmotion = MockEmotionsData.getMockData(for: .five).randomElement() ??
            EmotionCardModel(type: .calmness, date: Date())
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
