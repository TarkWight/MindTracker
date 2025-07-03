//
//  AddNoteViewModel.swift
//  MindTracker
//
//  Created by Tark Wight on 23.02.2025.
//

import Combine
import Foundation

final class AddNoteViewModel: ViewModel {
    weak var coordinator: AddNoteCoordinatorProtocol?

    // MARK: - Output

    @Published private(set) var selectedEmotion: EmotionCard?

    // MARK: - Init
    init(coordinator: AddNoteCoordinatorProtocol) {
        self.coordinator = coordinator
    }

    // MARK: - Events
    enum Event {
        case selectEmotion(EmotionType)
        case confirmSelection
        case dismiss
    }

    func handle(_ event: Event) {
        switch event {
        case let .selectEmotion(type):
            selectedEmotion = EmotionCard(
                id: UUID(),
                type: type,
                date: Date(),
                tags: EmotionTags(activity: [], people: [], location: [])
            )
        case .confirmSelection:
            confirmSelection()
        case .dismiss:
            dismiss()
        }
    }

    private func confirmSelection() {
        guard let emotion = selectedEmotion else {
            assertionFailure("Confirm tapped with no selected emotion")
            return
        }
        coordinator?.didSaveNoteTapped(with: emotion)
    }

    private func dismiss() {
        coordinator?.coordinatorDidFinish()
        coordinator?.navigationController.popViewController(animated: true)
    }
}
