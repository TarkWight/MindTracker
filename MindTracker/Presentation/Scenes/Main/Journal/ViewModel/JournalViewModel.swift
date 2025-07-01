//
//  JournalViewModel.swift
//  MindTracker
//
//  Created by Tark Wight on 22.02.2025.
//

import UIKit
import Combine

final class JournalViewModel: ViewModel {

    // MARK: - Dependencies

    weak var coordinator: JournalCoordinatorProtocol?
    private let storageService: EmotionServiceProtocol

    // MARK: - Published Properties

    @Published private(set) var todayEmotions: [EmotionCard] = []
    @Published private(set) var allEmotions: [EmotionCard] = []
    @Published private(set) var topColors: [UIColor] = []
    @Published private(set) var stats: EmotionStats?
    let spinnerData = CurrentValueSubject<SpinnerData?, Never>(nil)

    // MARK: - UI Constants

    let title = LocalizedKey.journalTitle
    let addNoteButtonTitle = LocalizedKey.journalAddNoteButton

    // MARK: - Private State

    private var emotions: [EmotionCard] = []
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(coordinator: JournalCoordinatorProtocol, storageService: EmotionServiceProtocol) {
        self.coordinator = coordinator
        self.storageService = storageService
        bindToEmotionUpdates()
    }

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

    // MARK: - Events

    enum Event {
        case refresh
        case viewDidLoad
        case addNoteButtonTapped
        case emotionSelected(EmotionCard)
    }

    func handle(_ event: Event) {
        switch event {
        case .viewDidLoad, .refresh:
            fetchEmotions()
        case .addNoteButtonTapped:
            coordinator?.showAddNote()
        case let .emotionSelected(emotion):
            coordinator?.didEmotionTapped(with: emotion)
        }
    }

    // MARK: - Data Loading

    private func fetchEmotions() {
        Task { @MainActor in
            do {
                emotions = try await storageService.fetchEmotions()
                updateOutputs()
            } catch {
                print("Ошибка загрузки эмоций: \(error)")
            }
        }
    }

    // MARK: - Output Calculation

    private func updateOutputs() {
        let today = getTodayEmotions()
        todayEmotions = today
        allEmotions = emotions.sorted { $0.date > $1.date }
        topColors = Array(today.prefix(2)).map { $0.type.category.color }
        stats = calculateStats()

        spinnerData.send(computeSpinnerData(from: today))
    }

    private func getTodayEmotions() -> [EmotionCard] {
        emotions.filter { Calendar.current.isDateInToday($0.date) }
    }

    private func calculateStats() -> EmotionStats {
        let total = emotions.count
        let today = todayEmotions.count
        let streak = calculateStreak()

        return EmotionStats(
            totalNotes: String(format: localizedTotalNotesKey(for: total), total),
            notesPerDay: String(format: localizedNotesPerDayKey(for: today), today),
            streak: String(format: localizedStreakKey(for: streak), streak)
        )
    }

    private func computeSpinnerData(from todayEmotions: [EmotionCard]) -> SpinnerData {
        let isLoading = todayEmotions.isEmpty
        let colors = extractTodayEmotionColors()
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

    private func calculateStreak() -> Int {
        guard !emotions.isEmpty else { return 0 }

        let sorted = Set(emotions.map { Calendar.current.startOfDay(for: $0.date) })
            .sorted(by: >)
        var streak = 0
        var current = Date()

        for date in sorted {
            if Calendar.current.isDate(date, inSameDayAs: current) {
                streak += 1
            } else if let expected = Calendar.current.date(byAdding: .day, value: -streak, to: Date()),
                      Calendar.current.isDate(date, inSameDayAs: expected) {
                streak += 1
            } else {
                break
            }
            current = date
        }

        return streak
    }
}

// MARK: - Private Methods

private extension JournalViewModel {

    private func bindToEmotionUpdates() {
        EmotionEventBus.shared.emotionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case let .added(emotion):
                    self?.allEmotions.insert(emotion, at: 0)
                    self?.updateOutputs()
                case let .updated(emotion):
                    if let index = self?.allEmotions.firstIndex(where: { $0.id == emotion.id }) {
                        self?.allEmotions[index] = emotion
                        self?.updateOutputs()
                    }
                }
            }
            .store(in: &cancellables)
    }

    func getEmotionColors() -> [UIColor] {
        return extractTodayEmotionColors()
    }

    func extractTodayEmotionColors() -> [UIColor] {
        let today = getTodayEmotions()
        return Array(today.prefix(2)).map { $0.type.category.color }
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
