//
//  StatisticsViewController.swift
//  MindTracker
//
//  Created by Tark Wight on 23.02.2025.
//

import Combine
import UIKit

final class StatisticsViewController: UIViewController, UIScrollViewDelegate {
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let pageIndicatorStack = UIStackView()
    private let numberOfSections = 4
    private var sectionViews: [UIView] = []

    private var cancellables = Set<AnyCancellable>()
    private var currentPage: Int = 0
    let viewModel: StatisticsViewModel

    private let weekFilterView = WeekFilterView()
    private let recordsLabel = UILabel()

    private let placeholderView = StatisticsPlaceholder()

    private let emotionOverviewView = EmotionOverviewView()
    private var emotionsByDaysView = EmotionsByDaysView()
    private var frequentEmotionsView = FrequentEmotionsView()

    private let moodOverTimeView = MoodOverTimeView()

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
        view.backgroundColor = AppColors.background

        setupViews()
        setupConstraints()
        setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        viewModel.handle(.loadData)
    }

    deinit {
        ConsoleLogger.classDeInitialized()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(
            origin: scrollView.contentOffset,
            size: scrollView.bounds.size
        )

        var maxIntersection: CGFloat = 0
        var bestIndex: Int = currentPage

        for (index, section) in sectionViews.enumerated() {
            let sectionFrameInScroll = section.convert(section.bounds, to: scrollView)
            let intersection = visibleRect.intersection(sectionFrameInScroll)

            let visibleHeight = intersection.height

            if visibleHeight > maxIntersection {
                maxIntersection = visibleHeight
                bestIndex = index
            }
        }

        if bestIndex != currentPage {
            currentPage = bestIndex
            updateDotIndicator(for: currentPage)
        }
    }
}

extension StatisticsViewController {
    fileprivate func addSection(
        title: String,
        content: UIView,
        heightMultiplier: CGFloat? = nil
    ) {
        let section = UIView()
        section.backgroundColor = AppColors.background

        let label = UILabel()
        label.text = title
        label.textColor = AppColors.appWhite
        label.font = Typography.header1
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false

        content.translatesAutoresizingMaskIntoConstraints = false

        section.addSubview(label)
        section.addSubview(content)

        var constraints: [NSLayoutConstraint] = [
            label.topAnchor.constraint(equalTo: section.topAnchor, constant: 24),
            label.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -24),

            content.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 24),
            content.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 16),
            content.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -16),
            content.bottomAnchor.constraint(equalTo: section.bottomAnchor, constant: -24),
        ]

        if let multiplier = heightMultiplier {
            constraints.append(
                content.heightAnchor.constraint(greaterThanOrEqualTo: section.heightAnchor, multiplier: multiplier)
            )
        }

        NSLayoutConstraint.activate(constraints)

        stackView.addArrangedSubview(section)
        sectionViews.append(section)
    }

    fileprivate func setupViews() {
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

            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])

        addSection(
            title: LocalizedKey.statisticsEmotionsOverview,
            content: emotionOverviewView,
            heightMultiplier: 0.775
        )

        addSection(
            title: LocalizedKey.statisticsEmotionsByDays,
            content: emotionsByDaysView
        )

        addSection(
            title: LocalizedKey.statisticsFrequentEmotions,
            content: frequentEmotionsView,
            heightMultiplier: 0.775
        )

        addSection(
            title: LocalizedKey.statisticsMoodOverTime,
            content: moodOverTimeView,
            heightMultiplier: 0.8
        )

        setupPageIndicator()
        setupGradientOverlay()
        setupPlaceholderView()
    }

    fileprivate func setupPlaceholderView() {
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.isHidden = true
        view.addSubview(placeholderView)

        NSLayoutConstraint.activate([
            placeholderView.topAnchor.constraint(equalTo: view.topAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            placeholderView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            placeholderView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
        ])
    }

    fileprivate func setupPageIndicator() {
        pageIndicatorStack.axis = .vertical
        pageIndicatorStack.spacing = 4
        pageIndicatorStack.alignment = .center
        pageIndicatorStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(pageIndicatorStack)

        for i in 0..<numberOfSections {
            let dot = UIView()
            dot.tag = i
            dot.backgroundColor =
                (i == 0 ? AppColors.appWhite : AppColors.appGrayLight)
            dot.layer.cornerRadius = 2
            dot.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                dot.widthAnchor.constraint(equalToConstant: 4),
                dot.heightAnchor.constraint(equalToConstant: 4),
            ])

            pageIndicatorStack.addArrangedSubview(dot)
        }
    }

    fileprivate func updateDotIndicator(for page: Int) {
        for (index, dot) in pageIndicatorStack.arrangedSubviews.enumerated() {
            dot.backgroundColor =
                index == page ? AppColors.appWhite : AppColors.appGrayLight
        }
    }

    fileprivate func setupGradientOverlay() {
        let gradientView = GradientView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.isUserInteractionEnabled = false
        view.addSubview(gradientView)

        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 74),
        ])

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.black.withAlphaComponent(0.0).cgColor,
            UIColor.black.withAlphaComponent(1.0).cgColor,
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

        gradientView.layer.insertSublayer(gradientLayer, at: 0)

        gradientView.layoutSubviewsCallback = {
            gradientLayer.frame = gradientView.bounds
        }
    }

    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            weekFilterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            weekFilterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weekFilterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            weekFilterView.heightAnchor.constraint(equalToConstant: 48),

            scrollView.topAnchor.constraint(equalTo: weekFilterView.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
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

    fileprivate func createBottomGradientOverlay() -> UIView {
        let gradientView = GradientView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.isUserInteractionEnabled = false

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            AppColors.emotionCardRed.withAlphaComponent(1.0).cgColor,
            AppColors.emotionCardGreen.withAlphaComponent(1.0).cgColor,
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = CGRect(
            x: 0,
            y: 0,
            width: view.bounds.width,
            height: 74
        )
        gradientView.layer.addSublayer(gradientLayer)
        gradientView.layoutSubviewsCallback = { gradientLayer.frame = gradientView.bounds }
        return gradientView
    }

    fileprivate func setupBindings() {
        viewModel.$availableWeeks
            .receive(on: RunLoop.main)
            .sink { [weak self] weeks in
                guard let self = self,
                    let selected = self.viewModel.selectedWeek ?? weeks.first
                else { return }

                self.weekFilterView.updateWeeks(weeks, selected: selected)
            }
            .store(in: &cancellables)

        viewModel.$emotionsOverviewData
            .combineLatest(viewModel.$totalRecords)
            .receive(on: RunLoop.main)
            .sink { [weak self] emotionsData, totalRecords in
                self?.updateUI(with: emotionsData, totalRecords: totalRecords)
            }
            .store(in: &cancellables)

        viewModel.$frequentEmotions
            .receive(on: RunLoop.main)
            .sink { [weak self] emotions in
                self?.frequentEmotionsView.configure(with: emotions)
            }
            .store(in: &cancellables)

        viewModel.$emotionsByDays
            .receive(on: RunLoop.main)
            .sink { [weak self] days in
                self?.emotionsByDaysView.update(with: days)
            }
            .store(in: &cancellables)

        viewModel.$moodColumns
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                self?.moodOverTimeView.configure(with: data)
            }
            .store(in: &cancellables)

        viewModel.$shouldShowPlaceholder
            .receive(on: RunLoop.main)
            .sink { [weak self] showPlaceholder in
                guard let self = self else { return }

                self.placeholderView.isHidden = !showPlaceholder
                self.weekFilterView.isHidden = showPlaceholder
                self.scrollView.isHidden = showPlaceholder
                self.pageIndicatorStack.isHidden = showPlaceholder
            }
            .store(in: &cancellables)
    }

    fileprivate func updateUI(
        with emotionsData: [EmotionCategory: Int],
        totalRecords: Int
    ) {
        recordsLabel.text = String(
            format: LocalizedKey.statisticsRecords,
            totalRecords
        )
        emotionOverviewView.configure(with: emotionsData)
    }
}
