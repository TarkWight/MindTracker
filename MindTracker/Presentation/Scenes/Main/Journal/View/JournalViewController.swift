//
//  JournalViewController.swift
//  MindTracker
//
//  Created by Tark Wight on 22.02.2025.
//

import Combine
import UIKit

final class JournalViewController: UIViewController, DisposableViewController {

    // MARK: - Properties

    let viewModel: JournalViewModel

    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let statsView = JournalStatsView()
    private let titleLabel = UILabel()

    private let emotionSpinnerView = EmotionSpinnerView(frame: .zero)

    private let emotionsStackView = UIStackView()

    // MARK: - Initialization

    init(viewModel: JournalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Background.color
        view.accessibilityIdentifier = JournalAccessibility.view

        setupUI()
        setupConstraints()
        setupBindings()

        emotionSpinnerView.onTap = { [weak self] in
            self?.viewModel.handle(.addNoteButtonTapped)
        }
        viewModel.handle(.viewDidLoad)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.coordinator?.cleanUpZombieCoordinators()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)

        viewModel.handle(.refresh)
        emotionSpinnerView.restartAnimationIfNeeded()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: - Public Methods

    func cleanUp() {
        viewModel.coordinator?.cleanUpZombieCoordinators()
    }

    // MARK: - Setup

    private func setupUI() {
        [
            scrollView, contentView, statsView, titleLabel, emotionSpinnerView,
            emotionsStackView,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        titleLabel.text = viewModel.title
        titleLabel.font = Constants.Title.font
        titleLabel.textColor = Constants.Title.color
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textAlignment = .left

        emotionsStackView.axis = .vertical
        emotionsStackView.spacing = ConstantsLayout.EmotionsStack.spacing

        scrollView.addSubview(contentView)
        contentView.addSubview(statsView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(emotionSpinnerView)
        contentView.addSubview(emotionsStackView)
        view.addSubview(scrollView)

        titleLabel.accessibilityIdentifier = JournalAccessibility.titleLabel
        emotionSpinnerView.accessibilityIdentifier = JournalAccessibility.emotionSpinner
        statsView.accessibilityIdentifier = JournalAccessibility.statsView
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(
                equalTo: scrollView.leadingAnchor
            ),
            contentView.trailingAnchor.constraint(
                equalTo: scrollView.trailingAnchor
            ),
            contentView.bottomAnchor.constraint(
                equalTo: scrollView.bottomAnchor
            ),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            statsView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: ConstantsLayout.StatsView.topSpacing
            ),
            statsView.centerXAnchor.constraint(
                equalTo: contentView.centerXAnchor
            ),
            statsView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: ConstantsLayout.StatsView.sidePadding
            ),

            titleLabel.topAnchor.constraint(
                equalTo: statsView.bottomAnchor,
                constant: ConstantsLayout.Title.topSpacing
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: ConstantsLayout.Title.sideSpacing
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -ConstantsLayout.Title.sideSpacing
            ),

            emotionSpinnerView.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: ConstantsLayout.ProgressRing.topSpacing
            ),
            emotionSpinnerView.centerXAnchor.constraint(
                equalTo: contentView.centerXAnchor
            ),
            emotionSpinnerView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: ConstantsLayout.ProgressRing.sideSpacing
            ),
            emotionSpinnerView.widthAnchor.constraint(
                equalToConstant: UIScreen.main.bounds.width - 48
            ),
            emotionSpinnerView.heightAnchor.constraint(
                equalToConstant: UIScreen.main.bounds.width - 48
            ),

            emotionsStackView.topAnchor.constraint(
                equalTo: emotionSpinnerView.bottomAnchor,
                constant: ConstantsLayout.EmotionsStack.topSpacing
            ),
            emotionsStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: ConstantsLayout.EmotionsStack.sideSpacing
            ),
            emotionsStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -ConstantsLayout.EmotionsStack.sideSpacing
            ),
            emotionsStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -ConstantsLayout.EmotionsStack.bottomSpacing
            ),
        ])
    }

    private func setupBindings() {
        viewModel.$allEmotions
            .receive(on: DispatchQueue.main)
            .sink { [weak self] emotions in
                self?.reloadEmotions(emotions)
            }
            .store(in: &cancellables)

        viewModel.$stats
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] stats in
                self?.statsView.updateLabels(stats: stats)
            }
            .store(in: &cancellables)

        viewModel.spinnerData
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] spinnerData in
                self?.emotionSpinnerView.update(with: spinnerData)
            }
            .store(in: &cancellables)
    }

    // MARK: - UI Updates

    private func reloadEmotions(_ emotions: [EmotionCard]) {
        emotionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for emotion in emotions {
            let card = EmotionCardView(emotion: emotion)
            card.onTap = { [weak self] in
                self?.viewModel.handle(.emotionSelected(emotion))
            }
            emotionsStackView.addArrangedSubview(card)
        }
    }
}

// MARK: - Constants

extension JournalViewController {
    fileprivate enum ConstantsLayout {
        enum Title {
            static let topSpacing: CGFloat = 32
            static let sideSpacing: CGFloat = 24
        }
        enum StatsView {
            static let topSpacing: CGFloat = 16
            static let sidePadding: CGFloat = 24
        }
        enum ProgressRing {
            static let sideSpacing: CGFloat = 24
            static let topSpacing: CGFloat = 32
        }
        enum EmotionsStack {
            static let spacing: CGFloat = 12
            static let topSpacing: CGFloat = 32
            static let sideSpacing: CGFloat = 24
            static let bottomSpacing: CGFloat = 16
        }
    }

    fileprivate enum Constants {
        enum Background {
            static let color = AppColors.background
        }
        enum Title {
            static let color = AppColors.appWhite
            static let font = Typography.header1
        }
    }
}

private enum JournalAccessibility {
    static let view = "tab_journal_vc"
    static let titleLabel = "journal_title_label"
    static let emotionSpinner = "journal_emotion_spinner"
    static let statsView = "journal_stats_view"
}
