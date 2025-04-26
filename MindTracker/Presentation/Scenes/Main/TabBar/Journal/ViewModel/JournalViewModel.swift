//
//  JournalViewModel.swift
//  MindTracker
//
//  Created by Tark Wight on 22.02.2025.
//

import UIKit

final class JournalViewModel: ViewModel {

    // MARK: - Dependencies

    weak var coordinator: JournalCoordinatorProtocol?

    // MARK: - Public Properties

    let title = LocalizedKey.journalTitle
    let addNoteButtonTitle = LocalizedKey.journalAddNoteButton

    var onDataUpdated: (() -> Void)?
    var onTodayEmotionsUpdated: (([EmotionCardModel]) -> Void)?
    var onAllEmotionsUpdated: (([EmotionCardModel]) -> Void)?
    var onTopColorsUpdated: (([UIColor]) -> Void)?
    var onStatsUpdated: ((EmotionStats) -> Void)?

    // MARK: - Private Properties

    private let mockDataType: MockDataType = .three
    private var emotions: [EmotionCardModel] = []

    // MARK: - Initialization

    init(coordinator: JournalCoordinatorProtocol) {
        self.coordinator = coordinator
    }

    // MARK: - Public Methods

    func handle(_ event: Event) {
        switch event {
        case .viewDidLoad:
            fetchEmotions()
        case .addNoteButtonTapped:
            addNewEmotion()
        case let .emotionSelected(emotion):
            openEmotionDetails(for: emotion)
        case .loadTodayEmotions:
            onTodayEmotionsUpdated?(getTodayEmotions())
        case .loadAllEmotions:
            onAllEmotionsUpdated?(getAllEmotions())
        case .loadTopEmotionColors:
            onTopColorsUpdated?(getEmotionColors())
        case .loadStats:
            onStatsUpdated?(getUpdatedStats())
        }
    }

    // MARK: - Events

    enum Event {
        case viewDidLoad
        case addNoteButtonTapped
        case emotionSelected(EmotionCardModel)
        case loadTodayEmotions
        case loadAllEmotions
        case loadTopEmotionColors
        case loadStats
    }
}

// MARK: - Private Methods

private extension JournalViewModel {

    func getTodayEmotions() -> [EmotionCardModel] {
        emotions.filter { Calendar.current.isDateInToday($0.date) }
    }

    func getAllEmotions() -> [EmotionCardModel] {
        emotions.sorted { $0.date > $1.date }
    }

    func getEmotionColors() -> [UIColor] {
        getTodayEmotions().prefix(2).map { $0.color }
    }

    func getUpdatedStats() -> EmotionStats {
        let totalCount = emotions.count
        let todayCount = getTodayEmotions().count
        let streakCount = calculateStreak()

        return EmotionStats(
            totalNotes: String(format: localizedTotalNotesKey(for: totalCount), totalCount),
            notesPerDay: String(format: localizedNotesPerDayKey(for: todayCount), todayCount),
            streak: String(format: localizedStreakKey(for: streakCount), streakCount)
        )
    }

    func fetchEmotions() {
        emotions = MockEmotionsData.getMockData(for: mockDataType)
        notifyObservers()
    }

    func addNewEmotion() {
        let newEmotion = EmotionCardModel(type: .random(), date: Date())
        emotions.append(newEmotion)
        notifyObservers()
        coordinator?.showAddNote()
    }

    func openEmotionDetails(for emotion: EmotionCardModel) {
        coordinator?.showNoteDetails(with: emotion)
        notifyObservers()
    }

    func notifyObservers() {
        onDataUpdated?()
        onTodayEmotionsUpdated?(getTodayEmotions())
        onAllEmotionsUpdated?(emotions)
    }

    func calculateStreak() -> Int {
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

    func localizedTotalNotesKey(for count: Int) -> String {
        switch count {
        case 1: return LocalizedKey.journalTotalNotes
        case 2...4: return LocalizedKey.journalTotalNotesFew
        default: return LocalizedKey.journalTotalNotesMany
        }
    }

    func localizedNotesPerDayKey(for count: Int) -> String {
        switch count {
        case 1: return LocalizedKey.journalNotesPerDay
        case 2...4: return LocalizedKey.journalNotesPerDayFew
        default: return LocalizedKey.journalNotesPerDayMany
        }
    }

    func localizedStreakKey(for count: Int) -> String {
        switch count {
        case 1: return LocalizedKey.journalStreak
        case 2...4: return LocalizedKey.journalStreakFew
        default: return LocalizedKey.journalStreakMany
        }
    }
}
