//
//  JournalViewModel.swift
//  MindTracker
//
//  Created by Tark Wight on 22.02.2025.
//


import Foundation
import Foundation
import UIKit

final class JournalViewModel: ViewModel {
    weak var coordinator: JournalCoordinatorProtocol?

    var score: Int = 4
    var totalNoteCount: Int = 2
    var countNotePerDay: Int = 0
    
    // MARK: - Emotions
    private let burnout: EmotionModel
    private let productivity: EmotionModel
    private let calm: EmotionModel
    private let anxiety: EmotionModel
    var emotions: [EmotionModel] = []

    var onStatsUpdated: ((String, String, String) -> Void)?

    init(coordinator: JournalCoordinatorProtocol) {
        self.coordinator = coordinator
        
        self.burnout = EmotionModel(
            name: "Выгорание",
            time: "вчера, 23:40",
            color: UIColor.blue,
            icon: EmotionIcons.burnout
        )
        
        self.productivity = EmotionModel(
            name: "Продуктивность",
            time: "воскресенье, 16:12",
            color: UIColor.orange,
            icon: EmotionIcons.productivity
        )
        
        self.calm = EmotionModel(
            name: "Спокойствие",
            time: "вчера, 14:08",
            color: UIColor.green,
            icon: EmotionIcons.calm
        )
        
        self.anxiety = EmotionModel(
            name: "Беспокойство",
            time: "воскресенье, 03:59",
            color: UIColor.red,
            icon: EmotionIcons.anxiety
        )

        self.emotions = [burnout, productivity, calm, anxiety]
    }

    func handle(_ event: Event) {
        switch event {
        case .addNote:
            addNote()
        case .didNoteSelected(let emotion):
            noteSelected(emotion)
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

// MARK: - Events & Logic
extension JournalViewModel {
    enum Event {
        case addNote
        case didNoteSelected(EmotionModel)
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
    
    private func noteSelected(_ emotion: EmotionModel) {
        coordinator?.showNoteDetails(with: emotion)
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

// MARK: - Emotion Icons
enum EmotionIcons {
    static let burnout = UIImage(named: "EmotionBlue")
    static let productivity = UIImage(named: "EmotionGreen")
    static let calm = UIImage(named: "EmotionYellow")
    static let anxiety = UIImage(named: "EmotionRed")
}
