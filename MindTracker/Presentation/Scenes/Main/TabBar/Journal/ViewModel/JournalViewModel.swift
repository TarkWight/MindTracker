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
    var onSpinnerDataUpdated: ((SpinnerData) -> Void)?

    // MARK: - Spinner Constants

    private enum SpinnerConstants {
        static let lineWidth: CGFloat               = 27
        static let startAngle: CGFloat              = -.pi / 2
        static let endAngle: CGFloat                = 3 * .pi / 2
        static let rotationDuration: CFTimeInterval = 15
        static let segmentGap: CGFloat              = 0.01
        static let spinnerFraction: CGFloat         = 0.283 // 360 / (3 * 135 * 3.14) | длину хорды рассчитал
        static let spinnerColors: [UIColor] = [
            AppColors.appGrayLight.withAlphaComponent(0.0),
            AppColors.appGrayLight.withAlphaComponent(0.0),
            AppColors.appGrayLight.withAlphaComponent(0.0),
            AppColors.appGrayLight.withAlphaComponent(0.6),
            AppColors.appGrayLight.withAlphaComponent(1.0)
        ]
        static let spinnerLocations: [CGFloat]      = [0.0, 0.3, 0.6, 0.8, 1.0]
    }

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
        emotions = MockEmotionsData.getMockData(for: .empty)
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

    func computeSpinnerData(todayEmotions: [EmotionCardModel]) -> SpinnerData {
        let isLoading = todayEmotions.isEmpty
        let colors = todayEmotions.map { $0.color }
        let count = max(2, colors.count)
        let unit = 1 / CGFloat(count)
        let segments = colors.enumerated().map { idx, color in
            SpinnerSegment(
                color: color,
                strokeStart: CGFloat(idx) * unit + SpinnerConstants.segmentGap,
                strokeEnd: CGFloat(idx + 1) * unit - SpinnerConstants.segmentGap
            )
        }
        return SpinnerData(
            isLoading: isLoading,
            segments: segments,
            gradientColors: SpinnerConstants.spinnerColors,
            gradientLocations: SpinnerConstants.spinnerLocations,
            animationDuration: SpinnerConstants.rotationDuration,
            lineWidth: SpinnerConstants.lineWidth,
            startAngle: SpinnerConstants.startAngle,
            endAngle: SpinnerConstants.endAngle,
            spinnerFraction: SpinnerConstants.spinnerFraction
        )
    }

    func notifyObservers() {
        onDataUpdated?()
        let today = getTodayEmotions()
        onTodayEmotionsUpdated?(today)
        onAllEmotionsUpdated?(emotions)
        onTopColorsUpdated?(getEmotionColors())
        onStatsUpdated?(getUpdatedStats())

        let spinnerData = computeSpinnerData(todayEmotions: today)
        onSpinnerDataUpdated?(spinnerData)
    }

    func calculateStreak() -> Int {
        guard !emotions.isEmpty else { return 0 }

        let sortedDates = Set(emotions.map { Calendar.current.startOfDay(for: $0.date) })
            .sorted(by: >)
        let calendar = Calendar.current
        var streak = 0
        var currentDate = Date()

        for date in sortedDates {
            if calendar.isDate(date, inSameDayAs: currentDate) {
                streak += 1
            } else if let previous = calendar.date(byAdding: .day, value: -streak, to: Date()),
                      calendar.isDate(date, inSameDayAs: previous) {
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
