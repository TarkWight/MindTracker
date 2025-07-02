//
//  StatisticsViewModel.swift
//  MindTracker
//
//  Created by Tark Wight on 23.02.2025.
//

import Combine
import Foundation
import UIKit

final class StatisticsViewModel: ViewModel {

    // MARK: - Dependencies

    weak var coordinator: StatisticsCoordinatorProtocol?
    private let emotionStorageService: EmotionServiceProtocol

    // MARK: - Properties

    private var cancellables = Set<AnyCancellable>()

    @Published private(set) var shouldShowPlaceholder = false
    @Published private(set) var emotions: [EmotionCard] = []
    @Published private(set) var emotionsOverviewData: [EmotionCategory: Int] =
        [:]
    @Published private(set) var totalRecords: Int = 0
    @Published private(set) var emotionsByDays: [EmotionDay] = []
    @Published private(set) var frequentEmotions: [EmotionType: Int] = [:]
    @Published private(set) var availableWeeks: [DateInterval] = []
    @Published var selectedWeek: DateInterval?
    @Published var selectedDay: Date?
    @Published private(set) var moodColumns: [MoodColumnData] = []
    private var isSettingInitialDay = false

    // MARK: - Initializers

    init(
        coordinator: StatisticsCoordinatorProtocol,
        emotionStorageService: EmotionServiceProtocol
    ) {
        self.emotionStorageService = emotionStorageService
        self.coordinator = coordinator
        setupBindings()
    }

    private func setupBindings() {
        $selectedWeek
            .compactMap { $0 }
            .sink { [weak self] week in
                self?.filterData(by: week)
            }
            .store(in: &cancellables)

        $selectedDay
            .compactMap { $0 }
            .sink { [weak self] day in
                guard let self = self, !isSettingInitialDay else { return }
                guard let week = selectedWeek else { return }
                filterData(by: week, day: day)
            }
            .store(in: &cancellables)
    }

    func handle(_ event: Event) {
        switch event {
        case .loadData:
            fetchData()
        case let .updateWeek(week):
            updateSelectedWeek(week)
        case let .updateDay(day):
            updateSelectedDay(day)
        }
    }

    // MARK: - Private Methods

    private func fetchData() {
        Task {
            do {
                let all = try await emotionStorageService.fetchEmotions()
                let sorted = all.sorted(by: { $0.date > $1.date })
                emotions = sorted
                availableWeeks = calculateAvailableWeeks(from: sorted)
                selectedWeek = availableWeeks.first
                if let firstWeek = selectedWeek {
                    moodColumns = makeMoodColumns(
                        from: emotions.filter { firstWeek.contains($0.date) }
                    )
                    filterData(by: firstWeek)
                }

                shouldShowPlaceholder = emotions.isEmpty

            } catch {
                print("Error fetching emotions: \(error)")
                shouldShowPlaceholder = true
            }
        }
    }

    private func updateSelectedWeek(_ week: DateInterval) {
        selectedWeek = week
        filterData(by: week)
        moodColumns = makeMoodColumns(
            from: emotions.filter { week.contains($0.date) }
        )
    }

    private func updateSelectedDay(_ day: Date) {
        selectedDay = day
        filterData(by: selectedWeek, day: day)
    }

    private func filterData(by week: DateInterval?, day: Date? = nil) {
        let filteredWeekData: [EmotionCard] = {
            guard let week else { return emotions }
            return emotions.filter { week.contains($0.date) }
        }()

        let filteredDayData: [EmotionCard] = {
            guard let day else { return filteredWeekData }
            return filteredWeekData.filter {
                Calendar.current.isDate($0.date, inSameDayAs: day)
            }
        }()

        shouldShowPlaceholder = filteredDayData.isEmpty

        var stats: [EmotionCategory: Int] = [:]
        var frequentEmotions: [EmotionType: Int] = [:]

        for card in filteredDayData {
            stats[card.type.category, default: 0] += 1
            frequentEmotions[card.type, default: 0] += 1
        }

        emotionsOverviewData = stats
        totalRecords = filteredDayData.count
        computeEmotionsByDays(filteredWeekData)
        self.frequentEmotions = frequentEmotions
    }

    private func calculateAvailableWeeks(from data: [EmotionCard])
        -> [DateInterval] {
        let calendar = Calendar.current
        let weeks = Set(
            data.compactMap {
                calendar.dateInterval(of: .weekOfYear, for: $0.date)
            }
        )
        return weeks.sorted(by: { $0.start > $1.start })
    }

    private func computeEmotionsByDays(_ data: [EmotionCard]) {
        let calendar = Calendar.current
        let weekDays = getFullWeekDays(from: selectedWeek)

        let groupedByDay = Dictionary(grouping: data) {
            calendar.startOfDay(for: $0.date)
        }

        emotionsByDays = weekDays.map { date in
            let dayEmotions = groupedByDay[date] ?? []

            let dateText =
                DateFormatter.weekDay.string(from: date) + "\n"
                + DateFormatter.shortDate.string(from: date)

            let emotionNames: [String] =
                dayEmotions.isEmpty ? [] : dayEmotions.map { $0.type.name }

            let emotionIcons: [UIImage] = {
                if dayEmotions.isEmpty {
                    return [AppIcons.emotionPlaceholder ?? UIImage()]
                } else {
                    return dayEmotions.map { $0.type.icon }
                }
            }()

            return EmotionDay(
                dateText: dateText,
                emotionsNames: emotionNames,
                emotionsIcons: emotionIcons
            )
        }
    }

    private func getFullWeekDays(from week: DateInterval?) -> [Date] {
        guard let week = week else { return [] }

        let calendar = Calendar.current
        let startOfWeek = calendar.startOfDay(for: week.start)

        var dates: [Date] = []
        for offset in 0..<7 {
            if let date = calendar.date(
                byAdding: .day,
                value: offset,
                to: startOfWeek
            ) {
                dates.append(date)
            }
        }

        return dates
    }

    private func makeMoodColumns(from data: [EmotionCard]) -> [MoodColumnData] {
        var result: [MoodColumnData] = []
        let calendar = Calendar.current

        for slot in TimeOfDaySlot.allCases {
            let emotionsForSlot = data.filter {
                let hour = calendar.component(.hour, from: $0.date)
                return TimeOfDaySlot.from(hour: hour) == slot
            }

            let emotionCounts = emotionsForSlot.reduce(
                into: [EmotionType: Int]()
            ) {
                $0[$1.type, default: 0] += 1
            }

            let total = emotionCounts.values.reduce(0, +)
            let title = slot.title + "\n\(total)"

            result.append(
                MoodColumnData(
                    emotions: emotionCounts,
                    total: total,
                    label: title
                )
            )
        }

        return result
    }

    private enum TimeOfDaySlot: Int, CaseIterable {
        case earlyMorning = 0
        case morning, day, evening, lateEvening

        static func from(hour: Int) -> TimeOfDaySlot {
            switch hour {
            case 5..<8: return .earlyMorning
            case 8..<12: return .morning
            case 12..<17: return .day
            case 17..<21: return .evening
            default: return .lateEvening
            }
        }

        var title: String {
            switch self {
            case .earlyMorning: return LocalizedKey.statisticsMoodEarlyMorning
            case .morning: return LocalizedKey.statisticsMoodMorning
            case .day: return LocalizedKey.statisticsMoodDay
            case .evening: return LocalizedKey.statisticsMoodEvening
            case .lateEvening: return LocalizedKey.statisticsMoodLateEvening
            }
        }
    }

}

// MARK: - Events

extension StatisticsViewModel {
    enum Event {
        case loadData
        case updateWeek(DateInterval)
        case updateDay(Date)
    }
}
