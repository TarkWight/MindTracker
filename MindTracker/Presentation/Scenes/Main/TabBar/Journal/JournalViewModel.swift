//
//  JournalViewModel.swift
//  MindTracker
//
//  Created by Tark Wight on 22.02.2025.
//


import Foundation
import UIKit

final class JournalViewModel: ViewModel {
    weak var coordinator: JournalCoordinatorProtocol?

    var score: Int = 4
    var totalNoteCount: Int = 2
    var countNotePerDay: Int = 0
    //MARK: - Emotions
    // выгорание
    let burnout: EmotionModel = EmotionModel(
        name: "Выгорание",
        time: "вчера, 23:40",
        color: UIColor.blue,
        icon: EmotionIcons.burnout!
    )
    
    let productivity: EmotionModel = EmotionModel(
        name: "Продуктивность",
        time: "воскресенье, 16:12",
        color: UIColor.orange,
        icon: EmotionIcons.productivity!
    )
    
    let calm: EmotionModel = EmotionModel(
        name: "Спокойствие",
        time: "вчера, 14:08",
        color: UIColor.green,
        icon: EmotionIcons.calm!
    )
    
    let anxiety: EmotionModel = EmotionModel(
        name: "Беспокойство",
        time: "воскресенье, 03:59",
        color: UIColor.red,
        icon: EmotionIcons.anxiety!
    )
    
    
    var onStatsUpdated: ((String, String, String) -> Void)?

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

    func updateStats(_ event: StatsEvent) {
        switch event {
        case .updateScore:
            score += 1
        case .updateNotes:
            totalNoteCount += 1
        case .updateCounter:
            countNotePerDay += 1
        }
        notifyStatsUpdated()
    }
}



extension JournalViewModel {
    enum Event {
        case addNote
        case didNoteSelected
    }

    enum StatsEvent {
        case updateScore
        case updateNotes
        case updateCounter
    }
    
    private func addNote() {
        coordinator?.showAddNote()
        updateStats(.updateNotes)
    }
    
    private func noteSelected() {
        coordinator?.showNoteDetails()
        updateStats(.updateScore)
    }
    
    private func notifyStatsUpdated() {
        let totalNotesText = String(format: getNotesLocalizationKey(for: totalNoteCount), totalNoteCount)
        let notesPerDayText = String(format: getNotesPerDayLocalizationKey(for: countNotePerDay), countNotePerDay)
        let streakText = String(format: getStreakLocalizationKey(for: score), score)

        onStatsUpdated?(totalNotesText, notesPerDayText, streakText)
    }
    
    private func getNotesLocalizationKey(for count: Int) -> String {
        switch count {
        case 1: return LocalizedKey.Journal.totalNotes
        case 2, 3, 4: return LocalizedKey.Journal.totalNotesFew
        default: return LocalizedKey.Journal.totalNotesMany
        }
    }

    private func getNotesPerDayLocalizationKey(for count: Int) -> String {
        switch count {
        case 1: return LocalizedKey.Journal.notesPerDay
        case 2, 3, 4: return LocalizedKey.Journal.notesPerDayFew
        default: return LocalizedKey.Journal.notesPerDayMany
        }
    }

    private func getStreakLocalizationKey(for count: Int) -> String {
        switch count {
        case 1: return LocalizedKey.Journal.streak
        case 2, 3, 4: return LocalizedKey.Journal.streakFew
        default: return LocalizedKey.Journal.streakMany
        }
    }
}

enum EmotionIcons {
    static let burnout = UIImage(named: "EmotionBlue")
    static let productivity = UIImage(named: "EmotionGreen")
    static let calm = UIImage(named: "EmotionYellow")
    static let anxiety = UIImage(named: "EmotionRed")
}
