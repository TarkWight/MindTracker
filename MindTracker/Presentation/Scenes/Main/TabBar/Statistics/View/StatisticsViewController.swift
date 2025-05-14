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
    private let weekFilterView = WeekFilterView()
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

        setupWeekFilterView()
        setupScrollView()
        setupStackView()
        setupSections()
        setupPageIndicator()
        setupGradientOverlay()
        setupBindings()

        viewModel.handle(.loadData)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Setup UI

    private func setupWeekFilterView() {
        weekFilterView.onWeekSelected = { [weak self] week in
            self?.viewModel.handle(.updateWeek(week))
        }
        weekFilterView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weekFilterView)

        NSLayoutConstraint.activate([
            weekFilterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            weekFilterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weekFilterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            weekFilterView.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    private func setupScrollView() {
        scrollView.isPagingEnabled = false
        scrollView.decelerationRate = .normal
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        scrollView.delegate = self

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: weekFilterView.bottomAnchor),
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
            section.backgroundColor = AppColors.background

            let label = UILabel()
            switch i {
            case 0:
                label.text = LocalizedKey.statisticsEmotionsOverview
            case 1:
                label.text = LocalizedKey.statisticsEmotionsByDays
            case 2:
                label.text = LocalizedKey.statisticsFrequentEmotions
            case 3:
                label.text = LocalizedKey.statisticsMoodOverTime
            default:
                label.text = "В будущем обновлении"
            }
            label.textColor = AppColors.appWhite
            label.textAlignment = .left
            label.numberOfLines = 2
            label.font = Typography.header1
            label.translatesAutoresizingMaskIntoConstraints = false
            section.addSubview(label)

            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: section.topAnchor, constant: 24),
                label.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 24),
                label.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -24)
            ])

            sectionViews.append(section)
            stackView.addArrangedSubview(section)
            section.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -280).isActive = true
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
            dot.backgroundColor = index == page ? AppColors.appWhite : AppColors.appGrayLight
        }
    }

    // MARK: - Gradient

    private func setupGradientOverlay() {
        let gradientView = GradientView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.isUserInteractionEnabled = false
        view.addSubview(gradientView)

        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            gradientView.heightAnchor.constraint(equalToConstant: 74)
        ])

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.black.withAlphaComponent(0.0).cgColor,
            UIColor.black.withAlphaComponent(1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

        gradientView.layer.insertSublayer(gradientLayer, at: 0)

        gradientView.layoutSubviewsCallback = {
            gradientLayer.frame = gradientView.bounds
        }
    }

    private func createBottomGradientOverlay() -> UIView {
        let gradientView = GradientView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.isUserInteractionEnabled = false

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            AppColors.emotionCardRed.withAlphaComponent(1.0).cgColor,
            AppColors.emotionCardGreen.withAlphaComponent(1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 74)
        gradientView.layer.addSublayer(gradientLayer)

        gradientView.layoutSubviewsCallback = {
            gradientLayer.frame = gradientView.bounds
        }

        return gradientView
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

    private func setupBindings() {
        viewModel.onWeeksUpdated = { [weak self] weeks in
            guard let selectedWeek = self?.viewModel.selectedWeek ?? weeks.first else { return }
            self?.weekFilterView.updateWeeks(weeks, selected: selectedWeek)
        }

        viewModel.onDataUpdated = { [weak self] emotionsData, totalRecords in
            self?.updateUI(with: emotionsData, totalRecords: totalRecords)
        }

//        viewModel.onFrequentEmotionsUpdated = { [weak self] frequentEmotions in
//            self?.frequentEmotionsView.configure(with: frequentEmotions)
//        }
    }

    private func updateUI(with emotionsData: [EmotionCategory: Int], totalRecords: Int) {
//        recordsLabel.text = String(format: LocalizedKey.statisticsRecords, totalRecords)
//        chartView.configure(with: emotionsData)
    }

    deinit {
        ConsoleLogger.classDeInitialized()
    }
}

private class GradientView: UIView {
    var layoutSubviewsCallback: (() -> Void)?

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutSubviewsCallback?()
    }
}
