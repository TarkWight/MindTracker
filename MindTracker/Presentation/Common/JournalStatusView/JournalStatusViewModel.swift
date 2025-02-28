//
//  JournalStatusViewModel.swift
//  MindTracker
//
//  Created by Tark Wight on 01.03.2025.
//

import Foundation

final class JournalStatusViewModel: UIUpdatableViewModel {

    var score: Int = 4
    var totalNoteCount: Int = 2
    var countNotePerDay: Int = 0
    
    var totalNotesText: String {
        let key = getNotesLocalizationKey(for: totalNoteCount)
        return String(format: key, totalNoteCount)
    }
    
    var notesPerDayText: String {
        let key = getNotesPerDayLocalizationKey(for: countNotePerDay)
        return String(format: key, countNotePerDay)
    }
    
    var streakText: String {
        let key = getStreakLocalizationKey(for: score)
        return String(format: key, score)
    }
    
    func updateUI(completion: @escaping () -> Void) {
        completion()
    }
}

extension JournalStatusViewModel {
    enum Event {
        case updateScore
        case updateNotes
        case updateCounter
    }
    
    func handle(_ event: Event, completion: @escaping () -> Void) {
        switch event {
        case .updateScore:
            updateScore()
        case .updateNotes:
            updateNotes()
        case .updateCounter:
            updateCounter()
        }
        updateUI(completion: completion)
    }
}

private extension JournalStatusViewModel {
    func updateScore() {
        score += 1
    }
    
    func updateNotes() {
        totalNoteCount += 1
    }
    
    func updateCounter() {
        countNotePerDay += 1
    }
    
    func getNotesLocalizationKey(for count: Int) -> String {
        switch count {
        case 1:
            return LocalizedKey.Journal.totalNotes
        case 2, 3, 4:
            return LocalizedKey.Journal.totalNotesFew
        default:
            return LocalizedKey.Journal.totalNotesMany
        }
    }
    
    func getNotesPerDayLocalizationKey(for count: Int) -> String {
        switch count {
        case 1:
            return LocalizedKey.Journal.notesPerDay
        case 2, 3, 4:
            return LocalizedKey.Journal.notesPerDayFew
        default:
            return LocalizedKey.Journal.notesPerDayMany
        }
    }
    
    func getStreakLocalizationKey(for count: Int) -> String {
        switch count {
        case 1:
            return LocalizedKey.Journal.streak
        case 2, 3, 4:
            return LocalizedKey.Journal.streakFew
        default:
            return LocalizedKey.Journal.streakMany
        }
    }
}
