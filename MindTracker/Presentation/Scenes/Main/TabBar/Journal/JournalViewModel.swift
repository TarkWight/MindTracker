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

    let backgroundColor = UITheme.Colors.background
    let titleColor = UITheme.Colors.appWhite
    let addNoteButtonColor = UITheme.Colors.appBlack

    let title = LocalizedKey.Journal.title
    let titleFont = UITheme.Font.JournalScene.title

    let addNoteButtonLabel = LocalizedKey.Journal.addNoteButton
    let addNoteButtonFont = UITheme.Font.JournalScene.addNoteButton

    private let mockDataType: MockDataType = .three
    private var emotions: [EmotionCardModel] = []

    var onDataUpdated: (() -> Void)?
    var onEmotionAdded: (([EmotionCardModel]) -> Void)?
    var onEmotionsUpdated: (([EmotionCardModel]) -> Void)?
    
    init(coordinator: JournalCoordinatorProtocol) {
        self.coordinator = coordinator
    }

    func loadData() {
        emotions = MockEmotionsData.getMockData(for: mockDataType)
        onDataUpdated?()
        onEmotionAdded?(getTodayEmotions())
        onEmotionsUpdated?(emotions)
    }

    func handle(_ event: Event) {
        switch event {
        case .addNote:
            addNote()
        case .didNoteSelected(let emotion):
            noteSelected(emotion)
        }
    }

    // MARK: - Data retrieval

    func getTodayEmotions() -> [EmotionCardModel] {
        return emotions.filter { Calendar.current.isDateInToday($0.date) }
    }

    func getAllEmotions() -> [EmotionCardModel] {
        return emotions.sorted(by: { $0.date > $1.date })
    }
    
    func getEmotionColors() -> [UIColor] {
        return Array(getTodayEmotions().prefix(2)).map { $0.color }
    }

    func getStats() -> (totalNotes: String, notesPerDay: String, streak: String) {
        let totalNotesCount = emotions.count
        let todayCount = getTodayEmotions().count
        let streakCount = calculateStreak()

        let totalNotesText = String(format: getNotesLocalizationKey(for: totalNotesCount), totalNotesCount)
        let notesPerDayText = String(format: getNotesPerDayLocalizationKey(for: todayCount), todayCount)
        let streakText = String(format: getStreakLocalizationKey(for: streakCount), streakCount)

        return (totalNotesText, notesPerDayText, streakText)
    }

    private func calculateStreak() -> Int {
        guard !emotions.isEmpty else { return 0 }

        let sortedDates = Set(emotions.map { Calendar.current.startOfDay(for: $0.date) }).sorted(by: >)
        let calendar = Calendar.current
        var streak = 0
        var currentDate = Date()

        for date in sortedDates {
            if calendar.isDate(date, inSameDayAs: currentDate) {
                streak += 1
            } else if let previousDate = calendar.date(byAdding: .day, value: -streak, to: Date()),
                      calendar.isDate(date, inSameDayAs: previousDate) {
                streak += 1
            } else {
                break
            }
            currentDate = date
        }

        return streak
    }

    // MARK: - Обновление данных

    private func addNote() {
        coordinator?.showAddNote()
        let newEmotion = EmotionCardModel(type: .random(), date: Date())
        emotions.append(newEmotion)

        onDataUpdated?()
        onEmotionAdded?(getTodayEmotions())
        onEmotionsUpdated?(emotions)
    }

    private func noteSelected(_ emotion: EmotionCardModel) {
        coordinator?.showNoteDetails(with: emotion)

        onDataUpdated?()
        onEmotionAdded?(getTodayEmotions())
        onEmotionsUpdated?(emotions)
    }

    // MARK: - Localization statistics

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

// MARK: - Events
extension JournalViewModel {
    enum Event {
        case addNote
        case didNoteSelected(EmotionCardModel)
    }
}

// MARK: - EmotionType Helper (generate a random emotion)
extension EmotionType {
    static func random() -> EmotionType {
        return allCases.randomElement() ?? .calmness
    }
}
