//
//  StatisticsViewController.swift
//  MindTracker
//
//  Created by Tark Wight on 23.02.2025.
//

import UIKit

final class StatisticsViewController: UIViewController {
    let viewModel: StatisticsViewModel

    private let weekFilterView = WeekFilterView()

    init(viewModel: StatisticsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewModel.backgroundColor

        setupUI()
        setupBindings()

        viewModel.handle(.loadData)
    }

    private func setupUI() {
        weekFilterView.onWeekSelected = { [weak self] week in
            self?.viewModel.handle(.updateWeek(week))
        }
        view.addSubview(weekFilterView)
        weekFilterView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            weekFilterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            weekFilterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weekFilterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            weekFilterView.heightAnchor.constraint(equalToConstant: 48),
        ])
    }

    private func setupBindings() {
        viewModel.onWeeksUpdated = { [weak self] weeks in
            guard let selectedWeek = self?.viewModel.selectedWeek ?? weeks.first else { return }
            self?.weekFilterView.updateWeeks(weeks, selected: selectedWeek)
        }
    }

    deinit {
        ConsoleLogger.classDeInitialized()
    }
}
