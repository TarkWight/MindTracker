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
    weak var coordinator: StatisticsCoordinatorProtocol?

    // MARK: - UI Properties
    let backgroundColor = UITheme.Colors.background
    let sectionFont = UITheme.Font.StatisticsScene.title
    let sectionTextColor = UITheme.Colors.appWhite

    // MARK: - Localized Keys
    let emotionsOverviewTitle = LocalizedKey.Statistics.emotionsOverview
    let totalRecordsText = LocalizedKey.Statistics.records
    let emotionsByDaysTitle = LocalizedKey.Statistics.emotionsByDays
    let frequentEmotionsTitle = LocalizedKey.Statistics.frequentEmotions
    let moodOverTimeTitle = LocalizedKey.Statistics.moodOverTime

    // MARK: - Properties
    private var mockData: [EmotionCardModel] = []
    private var emotionsOverviewData: [EmotionCategory: Int] = [:]
    private var emotionsByDays: [EmotionDayModel] = []
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

    // MARK: - Initializers
    init(coordinator: StatisticsCoordinatorProtocol) {
        self.coordinator = coordinator
        handle(.loadData)
    }

    func handle(_ event: Event) {
        switch event {
        case .loadData:
            loadMockData()
        case .updateWeek(let week):
            updateSelectedWeek(week)
        case .updateDay(let day):
            updateSelectedDay(day)
        }
    }
    
    // MARK: - Private
    private func loadMockData() {
        mockData = MockEmotionsData.getMockData(for: .sixteen)
        availableWeeks = calculateAvailableWeeks(from: mockData)

        guard !availableWeeks.isEmpty else {
            onWeeksUpdated?([])
            return
        }

        let initialWeek = availableWeeks.first!
        selectedWeek = initialWeek
        onWeeksUpdated?(availableWeeks)
        handle(.updateWeek(initialWeek))
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
        filteredDayData.forEach { stats[$0.type.category, default: 0] += 1 }

        emotionsOverviewData = stats
        totalRecords = filteredDayData.count
        onDataUpdated?(emotionsOverviewData, totalRecords)

        computeEmotionsByDays(filteredWeekData)
    }

    private func calculateAvailableWeeks(from data: [EmotionCardModel]) -> [DateInterval] {
        let calendar = Calendar.current
        let weeks = Set(data.compactMap { calendar.dateInterval(of: .weekOfYear, for: $0.date) })
        return weeks.sorted(by: { $0.start > $1.start })
    }

    private func computeEmotionsByDays(_ data: [EmotionCardModel]) {
        let calendar = Calendar.current
        let groupedByDay = Dictionary(grouping: data) { calendar.startOfDay(for: $0.date) }

        emotionsByDays = groupedByDay.map { (date, emotions) in
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "EEEE"
            let day = dayFormatter.string(from: date)

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM"
            let formattedDate = dateFormatter.string(from: date)

            return EmotionDayModel(day: day, date: formattedDate, emotions: emotions)
        }.sorted { $0.date > $1.date }

        onDaysUpdated?(emotionsByDays)

        if selectedDay == nil, let firstDay = emotionsByDays.first?.emotions.first?.date {
            selectedDay = firstDay
            onDayChanged?(firstDay)
        }
    }
}

extension StatisticsViewModel {
    enum Event {
        case loadData
        case updateWeek(DateInterval)
        case updateDay(Date)
    }
}
