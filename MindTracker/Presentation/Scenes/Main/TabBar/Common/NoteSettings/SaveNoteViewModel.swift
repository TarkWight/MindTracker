//
//  SaveNoteViewModel.swift
//  MindTracker
//
//  Created by Tark Wight on 23.02.2025.
//


import Foundation

final class SaveNoteViewModel: ViewModel {
    weak var coordinator: SaveNoteCoordinatorProtocol?

    init(coordinator: SaveNoteCoordinatorProtocol) {
        self.coordinator = coordinator
    }

    func handle(_ event: Event) {
        switch event {
        case .saveNote:
            saveNote()
        }
    }
}

extension SaveNoteViewModel {
    enum Event {
        case saveNote
    }
    
    private func saveNote() {
        coordinator?.saveNote()
    }
}
