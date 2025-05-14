//
//  StatisticsViewController.swift
//  MindTracker
//
//  Created by Tark Wight on 23.02.2025.
//

import UIKit

final class StatisticsViewController: UIViewController, UIScrollViewDelegate {
    // MARK: - UI Elements

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let pageIndicatorStack = UIStackView()

    private let numberOfSections = 4
    private var sectionViews: [UIView] = []

    // MARK: - Properties

    private var currentPage: Int = 0
    let viewModel: StatisticsViewModel
//
//    private let scrollView = UIScrollView()
//    private let contentView = UIView()
//    private let weekFilterView = WeekFilterView()
//    private let titleLabel = UILabel()
//    private let recordsLabel = UILabel()
//    private let chartView = GroupedEmotionsChartView()
//    private let emotionsByDaysView: EmotionsByDaysView
//    private let frequentEmotionsView: FrequentEmotionsView

    // MARK: - Init

    init(viewModel: StatisticsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

//        emotionsByDaysView = EmotionsByDaysView(viewModel: viewModel)
//        frequentEmotionsView = FrequentEmotionsView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.background
        setupScrollView()
        setupStackView()
        setupSections()
        setupPageIndicator()
//        setupUI()
//        setupBindings()

        viewModel.handle(.loadData)
    }

    // MARK: - Setup

    private func setupScrollView() {
        scrollView.isPagingEnabled = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        scrollView.delegate = self

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupStackView() {
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func setupSections() {
        for i in 0..<numberOfSections {
            let section = UIView()
            section.backgroundColor = UIColor(
                hue: CGFloat(i) / CGFloat(numberOfSections),
                saturation: 0.4,
                brightness: 1.0,
                alpha: 1.0
            )

            let label = UILabel()
            label.text = "Секция \(i + 1)"
            label.textColor = .white
            label.font = UIFont.boldSystemFont(ofSize: 28)
            label.translatesAutoresizingMaskIntoConstraints = false
            section.addSubview(label)

            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: section.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: section.centerYAnchor)
            ])

            sectionViews.append(section)
            stackView.addArrangedSubview(section)

            section.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        }
    }

    private func setupPageIndicator() {
        pageIndicatorStack.axis = .vertical
        pageIndicatorStack.spacing = 4
        pageIndicatorStack.alignment = .center
        pageIndicatorStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(pageIndicatorStack)

        NSLayoutConstraint.activate([
            pageIndicatorStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            pageIndicatorStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            pageIndicatorStack.widthAnchor.constraint(equalToConstant: 4),
            pageIndicatorStack.heightAnchor.constraint(equalToConstant: CGFloat(numberOfSections * 4 + (numberOfSections - 1) * 4))
        ])

        for i in 0..<numberOfSections {
            let dot = UIView()
            dot.tag = i
            dot.backgroundColor = (i == 0 ? AppColors.appWhite : AppColors.appGrayLight)
            dot.layer.cornerRadius = 2
            dot.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                dot.widthAnchor.constraint(equalToConstant: 4),
                dot.heightAnchor.constraint(equalToConstant: 4)
            ])

            pageIndicatorStack.addArrangedSubview(dot)
        }
    }

    private func updateDotIndicator(for page: Int) {
        for (index, dot) in pageIndicatorStack.arrangedSubviews.enumerated() {
            dot.backgroundColor = index == page ? .white : UIColor.white.withAlphaComponent(0.3)
        }
    }

    // MARK: - UIScrollViewDelegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.height
        guard height != 0 else { return }

        let page = Int(round(scrollView.contentOffset.y / height))

        if page != currentPage {
            currentPage = page
            updateDotIndicator(for: page)
        }
    }

    // MARK: - UI Setup

//    private func setupUI() {
//        weekFilterView.onWeekSelected = { [weak self] week in
//            self?.viewModel.handle(.updateWeek(week))
//        }
//        weekFilterView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(weekFilterView)
//
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.alwaysBounceVertical = true
//        view.addSubview(scrollView)
//
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.addSubview(contentView)
//
//        titleLabel.text = viewModel.emotionsOverviewTitle
//        titleLabel.font = viewModel.sectionFont
//        titleLabel.textColor = viewModel.sectionTextColor
//        titleLabel.numberOfLines = 2
//        titleLabel.textAlignment = .left
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(titleLabel)
//
//        recordsLabel.font = Typography.header4
//        recordsLabel.textColor = AppColors.appWhite.withAlphaComponent(0.7)
//        recordsLabel.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(recordsLabel)
//
//        chartView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(chartView)
//
//        emotionsByDaysView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(emotionsByDaysView)
//
//        frequentEmotionsView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(frequentEmotionsView)
//
//        NSLayoutConstraint.activate([
//            weekFilterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            weekFilterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            weekFilterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            weekFilterView.heightAnchor.constraint(equalToConstant: 48),
//
//            scrollView.topAnchor.constraint(equalTo: weekFilterView.bottomAnchor, constant: 8),
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//
//            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
//
//            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
//            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
//            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
//
//            recordsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
//            recordsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
//
//            chartView.topAnchor.constraint(equalTo: recordsLabel.bottomAnchor, constant: 24),
//            chartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
//            chartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
//            chartView.heightAnchor.constraint(equalToConstant: 430),
//
////            chartView.heightAnchor.constraint(equalToConstant: 580),
////            chartView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4),
//
//            emotionsByDaysView.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 24),
//            emotionsByDaysView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            emotionsByDaysView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//
//            frequentEmotionsView.topAnchor.constraint(equalTo: emotionsByDaysView.bottomAnchor, constant: 24),
//            frequentEmotionsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            frequentEmotionsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            frequentEmotionsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
//        ])
//    }

    // MARK: - Bindings

//    private func setupBindings() {
//        viewModel.onWeeksUpdated = { [weak self] weeks in
//            guard let selectedWeek = self?.viewModel.selectedWeek ?? weeks.first else { return }
//            self?.weekFilterView.updateWeeks(weeks, selected: selectedWeek)
//        }
//
//        viewModel.onDataUpdated = { [weak self] emotionsData, totalRecords in
//            self?.updateUI(with: emotionsData, totalRecords: totalRecords)
//        }
//
//        viewModel.onFrequentEmotionsUpdated = { [weak self] frequentEmotions in
//            self?.frequentEmotionsView.configure(with: frequentEmotions)
//        }
//    }

//    private func updateUI(with emotionsData: [EmotionCategory: Int], totalRecords: Int) {
//        recordsLabel.text = String(format: LocalizedKey.statisticsRecords, totalRecords)
//        chartView.configure(with: emotionsData)
//    }

    deinit {
        ConsoleLogger.classDeInitialized()
    }
}
