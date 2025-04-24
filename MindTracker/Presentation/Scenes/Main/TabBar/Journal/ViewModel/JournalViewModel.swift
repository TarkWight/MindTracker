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

    let backgroundColor = AppColors.background
    let titleColor = AppColors.appWhite
    let addNoteButtonColor = AppColors.appWhite

    let title = LocalizedKey.journalTitle
    let titleFont = Typography.header1

    let addNoteButtonLabel = LocalizedKey.journalAddNoteButton
    let addNoteButtonFont = Typography.body

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
        case let .didNoteSelected(emotion):
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

    func getStats() -> EmotionStats {
        return EmotionStats(
            totalNotes: String(format: getNotesLocalizationKey(for: emotions.count), emotions.count),
            notesPerDay: String(format: getNotesPerDayLocalizationKey(for: getTodayEmotions().count), getTodayEmotions().count),
            streak: String(format: getStreakLocalizationKey(for: calculateStreak()), calculateStreak())
        )
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
            } else if let previousDate = calendar.date(byAdding: .day, value: -streak, to: Date()), calendar.isDate(date, inSameDayAs: previousDate) {
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
        case 1: return LocalizedKey.journalTotalNotes
        case 2, 3, 4: return LocalizedKey.journalTotalNotesFew
        default: return LocalizedKey.journalTotalNotesMany
        }
    }

    private func getNotesPerDayLocalizationKey(for count: Int) -> String {
        switch count {
        case 1: return LocalizedKey.journalNotesPerDay
        case 2, 3, 4: return LocalizedKey.journalNotesPerDayFew
        default: return LocalizedKey.journalNotesPerDayMany
        }
    }

    private func getStreakLocalizationKey(for count: Int) -> String {
        switch count {
        case 1: return LocalizedKey.journalStreak
        case 2, 3, 4: return LocalizedKey.journalStreakFew
        default: return LocalizedKey.journalStreakMany
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
