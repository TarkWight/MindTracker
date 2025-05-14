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

    private let weekFilterView = WeekFilterView()
    private let recordsLabel = UILabel()
    private let emotionOverviewView = EmotionOverviewView()
    private var emotionsByDaysView: EmotionsByDaysView
    private var frequentEmotionsView = FrequentEmotionsView()

    // MARK: - Init

    init(viewModel: StatisticsViewModel) {
        self.viewModel = viewModel
        emotionsByDaysView = EmotionsByDaysView(viewModel: viewModel)

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.background

        setupViews()
        setupConstraints()
        setupBindings()

        viewModel.handle(.loadData)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Setup UI

    private func setupViews() {
        stackView.axis = .vertical
        stackView.distribution = .fill

        weekFilterView.onWeekSelected = { [weak self] week in
            self?.viewModel.handle(.updateWeek(week))
        }

        scrollView.isPagingEnabled = false
        scrollView.decelerationRate = .normal
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        scrollView.delegate = self

        [weekFilterView, scrollView, pageIndicatorStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),

            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        setupEmotionOverviewSection()
        setupEmotionsByDaysSection()
        setupFrequentEmotionsSection()
        setupMoodOverTimeSection()
        setupPageIndicator()
        setupGradientOverlay()
    }

    private func setupEmotionOverviewSection() {
        let section = UIView()
        let label = UILabel()
        section.backgroundColor = AppColors.background

        label.text = LocalizedKey.statisticsEmotionsOverview
        label.textColor = AppColors.appWhite
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = Typography.header1

        recordsLabel.font = Typography.header4
        recordsLabel.textColor = AppColors.appWhite

        [label, recordsLabel, emotionOverviewView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            section.addSubview($0)
        }

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: section.topAnchor, constant: 24),
            label.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -24),

            recordsLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            recordsLabel.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 24),

            emotionOverviewView.topAnchor.constraint(equalTo: recordsLabel.bottomAnchor, constant: 24),
            emotionOverviewView.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 24),
            emotionOverviewView.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -24),
            emotionOverviewView.heightAnchor.constraint(equalToConstant: 430),
            emotionOverviewView.bottomAnchor.constraint(equalTo: section.bottomAnchor, constant: -24)
        ])

        sectionViews.append(section)
        stackView.addArrangedSubview(section)
    }

    private func setupEmotionsByDaysSection() {
        let section = UIView()
        section.backgroundColor = AppColors.background

        let label = UILabel()
        label.text = LocalizedKey.statisticsEmotionsByDays

        label.textColor = AppColors.appWhite
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = Typography.header1
        label.translatesAutoresizingMaskIntoConstraints = false
        section.addSubview(label)

        emotionsByDaysView.translatesAutoresizingMaskIntoConstraints = false
        section.addSubview(emotionsByDaysView)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: section.topAnchor, constant: 32),
            label.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -24),

            emotionsByDaysView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 24),
            emotionsByDaysView.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 16),
            emotionsByDaysView.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -16),
            emotionsByDaysView.heightAnchor.constraint(equalToConstant: 456),
            emotionsByDaysView.bottomAnchor.constraint(equalTo: section.bottomAnchor, constant: -24)
        ])

        sectionViews.append(section)
        stackView.addArrangedSubview(section)
    }

    private func setupFrequentEmotionsSection() {
        let section = UIView()
        section.backgroundColor = AppColors.background

        let label = UILabel()
        label.text = LocalizedKey.statisticsFrequentEmotions

        label.textColor = AppColors.appWhite
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = Typography.header1
        label.translatesAutoresizingMaskIntoConstraints = false
        section.addSubview(label)

        frequentEmotionsView.translatesAutoresizingMaskIntoConstraints = false
        section.addSubview(frequentEmotionsView)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: section.topAnchor, constant: 24),
            label.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -24),

            frequentEmotionsView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 24),
            frequentEmotionsView.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 16),
            frequentEmotionsView.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -16),
            frequentEmotionsView.bottomAnchor.constraint(equalTo: section.bottomAnchor, constant: -24),
        ])

        sectionViews.append(section)
        stackView.addArrangedSubview(section)
    }

    private func setupMoodOverTimeSection() {
        let section = UIView()
        section.backgroundColor = AppColors.background

        let label = UILabel()
        label.text = LocalizedKey.statisticsMoodOverTime

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
    }

    private func setupPageIndicator() {
        pageIndicatorStack.axis = .vertical
        pageIndicatorStack.spacing = 4
        pageIndicatorStack.alignment = .center
        pageIndicatorStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(pageIndicatorStack)

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
            gradientView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            weekFilterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            weekFilterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weekFilterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            weekFilterView.heightAnchor.constraint(equalToConstant: 48),

            scrollView.topAnchor.constraint(equalTo: weekFilterView.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            pageIndicatorStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            pageIndicatorStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            pageIndicatorStack.widthAnchor.constraint(equalToConstant: 4),
            pageIndicatorStack.heightAnchor.constraint(equalToConstant: CGFloat(numberOfSections * 4 + (numberOfSections - 1) * 4)),
        ])
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

    // MARK: - Bindings

    private func setupBindings() {
        viewModel.onWeeksUpdated = { [weak self] weeks in
            guard let selectedWeek = self?.viewModel.selectedWeek ?? weeks.first else { return }
            self?.weekFilterView.updateWeeks(weeks, selected: selectedWeek)
        }

        viewModel.onDataUpdated = { [weak self] emotionsData, totalRecords in
            self?.updateUI(with: emotionsData, totalRecords: totalRecords)
        }

        viewModel.onFrequentEmotionsUpdated = { [weak self] frequentEmotions in
            self?.frequentEmotionsView.configure(with: frequentEmotions)
        }
    }

    private func updateUI(with emotionsData: [EmotionCategory: Int], totalRecords: Int) {
        recordsLabel.text = String(format: LocalizedKey.statisticsRecords, totalRecords)
        emotionOverviewView.configure(with: emotionsData)
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
