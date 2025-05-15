//
//  StatisticsViewModel.swift
//  MindTracker
//
//  Created by Tark Wight on 23.02.2025.
//

import Foundation
import UIKit

@MainActor
final class StatisticsViewModel: ViewModel {

    // MARK: - Dependencies

    weak var coordinator: StatisticsCoordinatorProtocol?
    private let emotionStorageService: EmotionStorageServiceProtocol

    // MARK: - UI Properties

    let backgroundColor = AppColors.background
    let sectionFont = Typography.header1
    let sectionTextColor = AppColors.appWhite

    // MARK: - Localized Keys

    let emotionsOverviewTitle = LocalizedKey.statisticsEmotionsOverview
    let totalRecordsText = LocalizedKey.statisticsRecords
    let emotionsByDaysTitle = LocalizedKey.statisticsEmotionsByDays
    let frequentEmotionsTitle = LocalizedKey.statisticsFrequentEmotions
    let moodOverTimeTitle = LocalizedKey.statisticsMoodOverTime

    // MARK: - Properties

    private var mockData: [EmotionCard] = []
    private var emotionsOverviewData: [EmotionCategory: Int] = [:]
    var emotionsByDays: [EmotionDayModel] = []
    private var totalRecords: Int = 0
    private var availableWeeks: [DateInterval] = []
    var selectedWeek: DateInterval?
    var selectedDay: Date?

    // MARK: - Callbacks

    var onDataUpdated: (([EmotionCategory: Int], Int) -> Void)?
    var onWeeksUpdated: (([DateInterval]) -> Void)?
    var onWeekChanged: ((DateInterval) -> Void)?
    var onDaysUpdated: (([EmotionDayModel]) -> Void)?
    var onDayChanged: ((Date) -> Void)?
    var onFrequentEmotionsUpdated: (([EmotionType: Int]) -> Void)?

    // MARK: - Initializers

    init(
        coordinator: StatisticsCoordinatorProtocol,
        emotionStorageService: EmotionStorageServiceProtocol
    ) {
        self.emotionStorageService = emotionStorageService
        self.coordinator = coordinator
        handle(.loadData)
    }

    func handle(_ event: Event) {
        switch event {
        case .loadData:
            loadMockData()
        case let .updateWeek(week):
            updateSelectedWeek(week)
        case let .updateDay(day):
            updateSelectedDay(day)
        }
    }

    // MARK: - Private Methods

    private func loadMockData() {
//        mockData = MockEmotionsData.getMockData(for: .sixteen)
//        availableWeeks = calculateAvailableWeeks(from: mockData)
//
//        guard let initialWeek = availableWeeks.first else {
//            onWeeksUpdated?([])
//            return
//        }
//
//        selectedWeek = initialWeek
//        onWeeksUpdated?(availableWeeks)
//        handle(.updateWeek(initialWeek))
    }

    private func updateSelectedWeek(_ week: DateInterval) {
        selectedWeek = week
        filterData(by: week)

        onWeekChanged?(week)
    }

    private func updateSelectedDay(_ day: Date) {
        selectedDay = day
        filterData(by: selectedWeek, day: day)

        onDayChanged?(day)
    }

    private func filterData(by week: DateInterval?, day: Date? = nil) {
        let filteredWeekData = week.map { week in
            mockData.filter { week.contains($0.date) }
        } ?? mockData

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

        onDataUpdated?(emotionsOverviewData, totalRecords)
        onFrequentEmotionsUpdated?(frequentEmotions)

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

        onDaysUpdated?(emotionsByDays)

        if selectedDay == nil, let firstDay = emotionsByDays.first?.emotions.first?.date {
            selectedDay = firstDay
            onDayChanged?(firstDay)
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

//    private func getPlaceholderEmotion(for date: Date) -> EmotionCardModel {
//        return EmotionCardModel(
//            type: EmotionType.placeholder,
//            date: date
//        )
//    }
}

// MARK: - Events

extension StatisticsViewModel {
    enum Event {
        case loadData
        case updateWeek(DateInterval)
        case updateDay(Date)
    }
}
