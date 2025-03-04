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
    private let titleLabel = UILabel()
    private let progressRingView = AddEntryWidgetView()
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
        view.backgroundColor = viewModel.backgroundColor

        setupUI()
        setupConstraints()
        setupBindings()

        viewModel.loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.coordinator?.cleanUpZombieCoordinators()
    }
    
    func cleanUp() {
        viewModel.coordinator?.cleanUpZombieCoordinators()
    }
    
    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        statsView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        progressRingView.translatesAutoresizingMaskIntoConstraints = false
        emotionsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = viewModel.title
        titleLabel.font = viewModel.titleFont
        titleLabel.textColor = viewModel.titleColor
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        
        emotionsStackView.axis = .vertical
        emotionsStackView.spacing = 12
        
        scrollView.addSubview(contentView)
        contentView.addSubview(statsView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(progressRingView)
        contentView.addSubview(emotionsStackView)
        view.addSubview(scrollView)

        progressRingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addNoteTapped)))
        progressRingView.setButtonTitle(viewModel.addNoteButtonLabel, textColor: viewModel.addNoteButtonColor, font: viewModel.addNoteButtonFont)
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

            statsView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            statsView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            titleLabel.topAnchor.constraint(equalTo: statsView.bottomAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            titleLabel.heightAnchor.constraint(equalToConstant: 88),

            progressRingView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            progressRingView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            progressRingView.widthAnchor.constraint(equalToConstant: 364),
            progressRingView.heightAnchor.constraint(equalToConstant: 364),

            emotionsStackView.topAnchor.constraint(equalTo: progressRingView.bottomAnchor, constant: 32),
            emotionsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emotionsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            emotionsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    private func reloadUI() {
        let stats = viewModel.getStats()
        statsView.updateLabels(totalRecords: stats.totalNotes, perDayRecords: stats.notesPerDay, streakDays: stats.streak)

        let todayEmotions = viewModel.getTodayEmotions()
        let allEmotions = viewModel.getAllEmotions() 

        progressRingView.setEmotionColors(viewModel.getEmotionColors())
        progressRingView.progressRing.forceRedraw()
        
        if todayEmotions.isEmpty || progressRingView.progressRing.currentColors.isEmpty {
            progressRingView.progressRing.startAnimation()
        } else {
            progressRingView.progressRing.stopAnimation()
        }

        reloadEmotions(allEmotions)
    }
    
    private func setupBindings() {
        viewModel.onDataUpdated = { [weak self] in
            self?.reloadUI()
        }
    }

    private func reloadEmotions(_ emotions: [EmotionCardModel]) {
        emotionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for emotion in emotions {
            let card = EmotionCardView(emotion: emotion)
            card.onTap = { [weak self] in
                self?.viewModel.handle(.didNoteSelected(emotion))
            }
            emotionsStackView.addArrangedSubview(card)
        }
    }
    
    @objc private func addNoteTapped() {
        viewModel.handle(.addNote)
    }
}
