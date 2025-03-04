//
//  StatisticsViewController.swift
//  MindTracker
//
//  Created by Tark Wight on 23.02.2025.
//

import UIKit

final class StatisticsViewController: UIViewController {
    let viewModel: StatisticsViewModel

    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    private let weekFilterView = WeekFilterView()
    private var emotionsChartView: EmotionsOverviewView?
    private var emotionsByDaysView: EmotionsByDaysView?

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

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        contentView.axis = .vertical
        contentView.spacing = 24
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            weekFilterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            weekFilterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weekFilterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            weekFilterView.heightAnchor.constraint(equalToConstant: 48),

            scrollView.topAnchor.constraint(equalTo: weekFilterView.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
        ])
    }

    private func setupBindings() {
        viewModel.onDataUpdated = { [weak self] emotionsData, totalRecords in
            self?.updateUI(with: emotionsData, totalRecords: totalRecords)
        }

        viewModel.onWeeksUpdated = { [weak self] weeks in
            guard let selectedWeek = self?.viewModel.selectedWeek ?? weeks.first else { return }
            self?.weekFilterView.updateWeeks(weeks, selected: selectedWeek)
        }
    }

    private func updateUI(with emotionsData: [EmotionCategory: Int], totalRecords: Int) {
        contentView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let chartView = EmotionsOverviewView(
            title: viewModel.emotionsOverviewTitle,
            recordsCount: totalRecords,
            data: emotionsData
        )
        chartView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addArrangedSubview(chartView)

        let daysView = EmotionsByDaysView(viewModel: viewModel)
        daysView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addArrangedSubview(daysView)

        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
    }

    deinit {
        ConsoleLogger.classDeInitialized()
    }
}
