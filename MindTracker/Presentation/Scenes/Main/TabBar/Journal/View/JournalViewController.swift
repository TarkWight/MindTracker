//
//  JournalViewController.swift
//  MindTracker
//
//  Created by Tark Wight on 22.02.2025.
//

import UIKit

final class JournalViewController: UIViewController, DisposableViewController {

    // MARK: - Properties

    private let viewModel: JournalViewModel

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let statsView = JournalStatsView()
    private let titleLabel = UILabel()
    private let progressRingView = AddEntryWidgetView()
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

        setupUI()
        setupConstraints()
        setupBindings()

        viewModel.handle(.viewDidLoad)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.coordinator?.cleanUpZombieCoordinators()
    }

    // MARK: - Public Methods

    func cleanUp() {
        viewModel.coordinator?.cleanUpZombieCoordinators()
    }

    // MARK: - Setup

    private func setupUI() {
        [scrollView, contentView, statsView, titleLabel, progressRingView, emotionsStackView].forEach {
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
        contentView.addSubview(progressRingView)
        contentView.addSubview(emotionsStackView)
        view.addSubview(scrollView)

        progressRingView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(addNoteTapped)
        ))

        progressRingView.setButtonTitle(
            viewModel.addNoteButtonTitle,
            textColor: Constants.AddButton.textColor,
            font: Constants.AddButton.font
        )
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            statsView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ConstantsLayout.StatsView.topInset),
            statsView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            titleLabel.topAnchor.constraint(equalTo: statsView.bottomAnchor, constant: ConstantsLayout.Title.topSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ConstantsLayout.Title.sideInset),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ConstantsLayout.Title.sideInset),

            progressRingView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ConstantsLayout.AddButton.topSpacing),
            progressRingView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            progressRingView.widthAnchor.constraint(equalToConstant: ConstantsLayout.AddButton.size),
            progressRingView.heightAnchor.constraint(equalToConstant: ConstantsLayout.AddButton.size),

            emotionsStackView.topAnchor.constraint(equalTo: progressRingView.bottomAnchor, constant: ConstantsLayout.EmotionsStack.topSpacing),
            emotionsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ConstantsLayout.EmotionsStack.sideInset),
            emotionsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ConstantsLayout.EmotionsStack.sideInset),
            emotionsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -ConstantsLayout.EmotionsStack.bottomInset)
        ])
    }

    private func setupBindings() {
        viewModel.onDataUpdated = { [weak self] in
            self?.reloadEverything()
        }
        viewModel.onTodayEmotionsUpdated = { [weak self] todayEmotions in
            self?.updateProgressRing(with: todayEmotions)
        }
        viewModel.onAllEmotionsUpdated = { [weak self] allEmotions in
            self?.reloadEmotions(allEmotions)
        }
        viewModel.onTopColorsUpdated = { [weak self] colors in
            self?.progressRingView.setEmotionColors(colors)
        }
        viewModel.onStatsUpdated = { [weak self] stats in
            self?.statsView.updateLabels(stats: stats)
        }
    }

    // MARK: - UI Updates

    private func reloadEverything() {
        viewModel.handle(.loadTodayEmotions)
        viewModel.handle(.loadAllEmotions)
        viewModel.handle(.loadTopEmotionColors)
        viewModel.handle(.loadStats)
    }

    private func updateProgressRing(with todayEmotions: [EmotionCardModel]) {
        let isEmpty = todayEmotions.isEmpty || progressRingView.progressRing.currentColors.isEmpty
        if isEmpty {
            progressRingView.progressRing.startAnimation()
        } else {
            progressRingView.progressRing.stopAnimation()
        }
        progressRingView.progressRing.forceRedraw()
    }

    private func reloadEmotions(_ emotions: [EmotionCardModel]) {
        emotionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for emotion in emotions {
            let card = EmotionCardView(emotion: emotion)
            card.onTap = { [weak self] in
                self?.viewModel.handle(.emotionSelected(emotion))
            }
            emotionsStackView.addArrangedSubview(card)
        }
    }

    // MARK: - Actions

    @objc private func addNoteTapped() {
        viewModel.handle(.addNoteButtonTapped)
    }
}

// MARK: - Constants

private extension JournalViewController {

    enum ConstantsLayout {

        enum Title {
            static let topSpacing: CGFloat = 32
            static let sideInset: CGFloat = 24
        }

        enum StatsView {
            static let topInset: CGFloat = 16
        }

        enum AddButton {
            static let size: CGFloat = 364
            static let topSpacing: CGFloat = 32
        }

        enum EmotionsStack {
            static let spacing: CGFloat = 12
            static let topSpacing: CGFloat = 32
            static let sideInset: CGFloat = 16
            static let bottomInset: CGFloat = 16
        }
    }
    
    enum Constants {

        enum Background {
            static let color = AppColors.background
        }

        enum Title {
            static let color = AppColors.appWhite
            static let font = Typography.header1
        }

        enum AddButton {
            static let font = Typography.body
            static let textColor = AppColors.appWhite
        }
    }
}
