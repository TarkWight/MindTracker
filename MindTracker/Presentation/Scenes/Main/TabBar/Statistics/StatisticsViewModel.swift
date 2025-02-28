//
//  StatisticsViewModel.swift
//  MindTracker
//
//  Created by Tark Wight on 23.02.2025.
//


import Foundation

@MainActor
final class StatisticsViewModel: ViewModel {
     weak var coordinator: StatisticsCoordinatorProtocol?

    init(coordinator: StatisticsCoordinatorProtocol) {
        self.coordinator = coordinator
    }

    func handle(_ event: Event) {
        // Пока нет событий для обработки
    }
}

extension StatisticsViewModel {
    enum Event {}
}
