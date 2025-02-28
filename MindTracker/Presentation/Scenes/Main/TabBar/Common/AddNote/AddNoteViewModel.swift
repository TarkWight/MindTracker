//
//  AddNoteViewModel.swift
//  MindTracker
//
//  Created by Tark Wight on 23.02.2025.
//


import Foundation

final class AddNoteViewModel: ViewModel {
     weak var coordinator: AddNoteCoordinatorProtocol?

    init(coordinator: AddNoteCoordinatorProtocol) {
        self.coordinator = coordinator
    }

    func handle(_ event: Event) {
        switch event {
        case .saveNote:
            saveNote()
        }
    }
}

extension AddNoteViewModel {
    enum Event {
        case saveNote
    }
    
    private func saveNote() {
        coordinator?.didSaveNoteTapped()
    }
}
