//
//  AddNoteViewModel.swift
//  MindTracker
//
//  Created by Tark Wight on 23.02.2025.
//

import Foundation

final class AddNoteViewModel: ViewModel {
    weak var coordinator: AddNoteCoordinatorProtocol?
    private var selectedEmotion: EmotionType?
    
    var onEmotionSelected: ((EmotionType) -> Void)?

    init(coordinator: AddNoteCoordinatorProtocol) {
        self.coordinator = coordinator
    }

    func handle(_ event: Event) {
        switch event {
        case .selectEmotion(let emotion):
            selectedEmotion = emotion
            onEmotionSelected?(emotion)
        case .confirmSelection:
            confirmSelection()
        case .dismiss:
            coordinator?.coordinatorDidFinish()
        }
    }

    enum Event {
        case selectEmotion(EmotionType)
        case confirmSelection
        case dismiss
    }
    
    func confirmSelection() {
        guard let emotion = selectedEmotion else { return }
        coordinator?.didSaveNoteTapped()
    }
}
