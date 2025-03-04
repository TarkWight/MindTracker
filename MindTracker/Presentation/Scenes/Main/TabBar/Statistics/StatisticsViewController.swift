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

    required init?(coder: NSCoder) {
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
        // 🔹 Фиксированный `weekFilterView` (навигация по неделям)
        weekFilterView.onWeekSelected = { [weak self] week in
            self?.viewModel.handle(.updateWeek(week))
        }
        view.addSubview(weekFilterView)
        weekFilterView.translatesAutoresizingMaskIntoConstraints = false

        // 🔹 Вертикальный `UIScrollView`
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        // 🔹 Контейнер для секций внутри `UIScrollView`
        contentView.axis = .vertical
        contentView.spacing = 24
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            // 🔹 Закрепляем `weekFilterView` наверху
            weekFilterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            weekFilterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weekFilterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            weekFilterView.heightAnchor.constraint(equalToConstant: 48),

            // 🔹 Настройки `UIScrollView`
            scrollView.topAnchor.constraint(equalTo: weekFilterView.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // 🔹 `UIStackView` внутри `UIScrollView`
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32) // Минус отступы
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
        // 🔹 Очищаем старые данные перед обновлением
        contentView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // 🔹 График эмоций
        let chartView = EmotionsOverviewView(
            title: viewModel.emotionsOverviewTitle,
            recordsCount: totalRecords,
            data: emotionsData
        )
        chartView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addArrangedSubview(chartView)

        // 🔹 Эмоции по дням
        let daysView = EmotionsByDaysView(viewModel: viewModel)
        daysView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addArrangedSubview(daysView)
    }

    deinit {
        ConsoleLogger.classDeInitialized()
    }
}
