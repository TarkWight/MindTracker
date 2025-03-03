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

    let backgroundColor = UITheme.Colors.background
    let titleColor = UITheme.Colors.appWhite
    let sectionFont = UITheme.Font.StatisticsScene.title
    let sectionTextColor = UITheme.Colors.appWhite

    let emotionsOverviewTitle = LocalizedKey.Statistics.emotionsOverview
    let totalRecordsText = LocalizedKey.Statistics.records
    
    let emotionsByDaysTitle = LocalizedKey.Statistics.emotionsByDays
    let frequentEmotionsTitle = LocalizedKey.Statistics.frequentEmotions
    let moodOverTimeTitle = LocalizedKey.Statistics.moodOverTime

    private var mockData: [EmotionCardModel] = []
    private var emotionsOverviewData: [EmotionCategory: Int] = [:]
    private var totalRecords: Int = 0

    var onDataUpdated: (([EmotionCategory: Int], Int) -> Void)? 

    init(coordinator: StatisticsCoordinatorProtocol) {
        self.coordinator = coordinator
        handle(.loadData)
    }

    func handle(_ event: Event) {
        switch event {
        case .loadData:
            loadMockData()
        }
    }

    private func loadMockData() {
        mockData = MockEmotionsData.getMockData(for: .sixteen)
        computeEmotionsOverview()
    }

    private func computeEmotionsOverview() {
        var stats: [EmotionCategory: Int] = [:]
        mockData.forEach { stats[$0.type.category, default: 0] += 1 }

        emotionsOverviewData = stats
        totalRecords = mockData.count
        onDataUpdated?(emotionsOverviewData, totalRecords)
    }
}

extension StatisticsViewModel {
    enum Event {
        case loadData
    }
}
