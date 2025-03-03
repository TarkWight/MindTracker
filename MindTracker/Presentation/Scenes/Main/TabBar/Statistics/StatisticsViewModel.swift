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
    let emotionsByDaysTitle = LocalizedKey.Statistics.emotionsByDays
    let frequentEmotionsTitle = LocalizedKey.Statistics.frequentEmotions
    let moodOverTimeTitle = LocalizedKey.Statistics.moodOverTime

    init(coordinator: StatisticsCoordinatorProtocol) {
        self.coordinator = coordinator
    }

    func handle(_ event: Event) {}
}

extension StatisticsViewModel {
    enum Event {}
}
