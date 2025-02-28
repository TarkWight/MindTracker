//
//  JournalViewModel.swift
//  MindTracker
//
//  Created by Tark Wight on 22.02.2025.
//


import Foundation

final class JournalViewModel: ViewModel {
    weak var coordinator: JournalCoordinatorProtocol?

    init(coordinator: JournalCoordinatorProtocol) {
        self.coordinator = coordinator
    }

    func handle(_ event: Event) {
        switch event {
        case .addNote:
            addNote()
        case .didNoteSelected:
            noteSelected()
        }
    }
}

extension JournalViewModel {
    enum Event {
        case addNote
        case didNoteSelected
    }
    
    private func addNote() {
        coordinator?.showAddNote()
    }
    
    private func noteSelected() {
        coordinator?.showNoteDetails()
    }
}
