//
//  JournalStatsView.swift
//  MindTracker
//
//  Created by Tark Wight on 28.02.2025.
//

import UIKit

final class JournalStatsView: UIView {

    // MARK: - UI Elements

    private let stackView = UIStackView()
    private let totalRecordsView = JournalStatsBadgeView()
    private let perDayRecordsView = JournalStatsBadgeView()
    private let streakView = JournalStatsBadgeView()

    // MARK: - Initializers

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI

    private func setupUI() {
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = ConstantsLayout.stackSpacing
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false

        [totalRecordsView, perDayRecordsView, streakView].forEach {
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
            stackView.addArrangedSubview($0)
        }

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            heightAnchor.constraint(equalToConstant: ConstantsLayout.height)
        ])
    }

    // MARK: - Public Methods

    func updateLabels(stats: EmotionStats) {
        totalRecordsView.setText(prefix: nil, value: stats.totalNotes)
        perDayRecordsView.setText(prefix: Constants.perDayText, value: stats.notesPerDay)
        streakView.setText(prefix: Constants.streakText, value: stats.streak)
    }
}

// MARK: - Constants

private extension JournalStatsView {
    enum ConstantsLayout {
        static let height: CGFloat = 32
        static let stackSpacing: CGFloat = 8
    }

    enum Constants {
        static let perDayText = LocalizedKey.journalPerDayPrefix
        static let streakText = LocalizedKey.journalStreakDaysPredix
    }
}
