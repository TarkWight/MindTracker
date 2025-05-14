//
//  AddNoteViewModel.swift
//  MindTracker
//
//  Created by Tark Wight on 23.02.2025.
//

import Foundation
import Combine

final class AddNoteViewModel: ViewModel {
    weak var coordinator: AddNoteCoordinatorProtocol?

    // MARK: - Output
    @Published private(set) var selectedEmotion: EmotionType?

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
        case let .selectEmotion(emotion):
            selectedEmotion = emotion
        case .confirmSelection:
            confirmSelection()
        case .dismiss:
            dismiss()
        }
    }

    private func confirmSelection() {
        guard let selectedEmotion else {
            assertionFailure("No emotion selected before confirming")
            return
        }
        coordinator?.didSaveNoteTapped(with: selectedEmotion)
    }

    private func dismiss() {
        coordinator?.coordinatorDidFinish()
        coordinator?.navigationController.popViewController(animated: true)
    }
}
