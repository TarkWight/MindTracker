//
//  JournalViewController.swift
//  MindTracker
//
//  Created by Tark Wight on 22.02.2025.
//

import UIKit

final class JournalViewController: UIViewController, DisposableViewController {
    let viewModel: JournalViewModel

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let statsView = JournalStatsView()
    private let emotionsStackView = UIStackView()

    init(viewModel: JournalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupScrollView()
        setupStatsView()
        setupEmotionsStackView()
        setupBindings()

        reloadEmotions()
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func setupStatsView() {
        statsView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(statsView)

        NSLayoutConstraint.activate([
            statsView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            statsView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }

    private func setupEmotionsStackView() {
        emotionsStackView.axis = .vertical
        emotionsStackView.spacing = 12
        emotionsStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emotionsStackView)

        NSLayoutConstraint.activate([
            emotionsStackView.topAnchor.constraint(equalTo: statsView.bottomAnchor, constant: 16),
            emotionsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emotionsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            emotionsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    private func setupBindings() {
           viewModel.onStatsUpdated = { [weak self] totalNotes, notesPerDay, streak in
               self?.statsView.updateLabels(totalRecords: totalNotes, perDayRecords: notesPerDay, streakDays: streak)
           }
       }
    private func reloadEmotions() {
        emotionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for emotion in viewModel.emotions {
            let card = EmotionCardView(emotion: emotion)
            card.onTap = { [weak self] in
                self?.viewModel.handle(.didNoteSelected(emotion))
            }
            emotionsStackView.addArrangedSubview(card)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isMovingFromParent {
            cleanUp()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.coordinator?.cleanUpZombieCoordinators()
    }

    func cleanUp() {
        viewModel.coordinator?.coordinatorDidFinish()
    }

    deinit {
        ConsoleLogger.classDeInitialized()
    }
}
