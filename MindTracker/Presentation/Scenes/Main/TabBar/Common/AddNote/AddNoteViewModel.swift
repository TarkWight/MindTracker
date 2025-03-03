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
            dismiss()
        }
    }

    enum Event {
        case selectEmotion(EmotionType)
        case confirmSelection
        case dismiss
    }
    
    private func confirmSelection() {
        coordinator?.didSaveNoteTapped()
    }
    
    private func dismiss() {
        coordinator?.coordinatorDidFinish()
        coordinator?.navigationController.popViewController(animated: true)
    }
}
