//
//  StatisticsViewModel.swift
//  MindTracker
//
//  Created by Tark Wight on 23.02.2025.
//

import Foundation
import UIKit
import Combine

@MainActor
final class StatisticsViewModel: ViewModel {

    // MARK: - Dependencies

    weak var coordinator: StatisticsCoordinatorProtocol?
    private let emotionStorageService: EmotionStorageServiceProtocol

    // MARK: - Properties

    private var cancellables = Set<AnyCancellable>()

    @Published private(set) var emotions: [EmotionCard] = []
    @Published private(set) var emotionsOverviewData: [EmotionCategory: Int] = [:]
    @Published private(set) var totalRecords: Int = 0
    @Published private(set) var emotionsByDays: [EmotionDayModel] = []
    @Published private(set) var frequentEmotions: [EmotionType: Int] = [:]
    @Published private(set) var availableWeeks: [DateInterval] = []
    @Published var selectedWeek: DateInterval?
    @Published var selectedDay: Date?

    // MARK: - Initializers

    init(
        coordinator: StatisticsCoordinatorProtocol,
        emotionStorageService: EmotionStorageServiceProtocol
    ) {
        self.emotionStorageService = emotionStorageService
        self.coordinator = coordinator
        setupBindings()
        handle(.loadData)
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
                guard let week = self?.selectedWeek else { return }
                self?.filterData(by: week, day: day)
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
            } catch {
                print("❌ Error fetching emotions: \(error)")
            }
        }
    }

    private func updateSelectedWeek(_ week: DateInterval) {
        selectedWeek = week
        filterData(by: week)
    }

    private func updateSelectedDay(_ day: Date) {
        selectedDay = day
        filterData(by: selectedWeek, day: day)
    }

    private func filterData(by week: DateInterval?, day: Date? = nil) {
        let filteredWeekData = week.map { week in
            emotions.filter { week.contains($0.date) }
        } ?? emotions

        let filteredDayData = day.map { selectedDay in
            filteredWeekData.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDay) }
        } ?? filteredWeekData

        var stats: [EmotionCategory: Int] = [:]
        var frequentEmotions: [EmotionType: Int] = [:]

        for filteredDayData in filteredDayData {
            stats[filteredDayData.type.category, default: 0] += 1
            frequentEmotions[filteredDayData.type, default: 0] += 1
        }

        emotionsOverviewData = stats
        totalRecords = filteredDayData.count

        computeEmotionsByDays(filteredWeekData)
    }

    private func calculateAvailableWeeks(from data: [EmotionCard]) -> [DateInterval] {
        let calendar = Calendar.current
        let weeks = Set(data.compactMap { calendar.dateInterval(of: .weekOfYear, for: $0.date) })
        return weeks.sorted(by: { $0.start > $1.start })
    }

    private func computeEmotionsByDays(_ data: [EmotionCard]) {
        let calendar = Calendar.current
        let weekDays = getFullWeekDays(from: selectedWeek)

        let groupedByDay = Dictionary(grouping: data) { calendar.startOfDay(for: $0.date) }

        emotionsByDays = weekDays.map { date in
            let emotions = groupedByDay[date] ?? []

            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "EEEE"
            let day = dayFormatter.string(from: date)

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM"
            let formattedDate = dateFormatter.string(from: date)

            return EmotionDayModel(
                day: day,
                date: formattedDate,
                emotions: /*emotions.isEmpty ? [getPlaceholderEmotion(for: date)] :*/ emotions
            )
        }

        if selectedDay == nil, let firstDay = emotionsByDays.first?.emotions.first?.date {
            selectedDay = firstDay
        }
    }

    private func getFullWeekDays(from week: DateInterval?) -> [Date] {
        guard let week = week else { return [] }

        var dates: [Date] = []
        var currentDate = week.start

        while currentDate <= week.end {
            dates.append(currentDate)

            guard let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }
            currentDate = nextDate
        }

        return dates
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
