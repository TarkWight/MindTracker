//
//  JournalStatsView.swift
//  MindTracker
//
//  Created by Tark Wight on 28.02.2025.
//


import UIKit

final class JournalStatsView: UIView {
    
    private let stackView = UIStackView()
    private let totalRecordsView = JournalStatsBadgeView()
    private let perDayRecordsView = JournalStatsBadgeView()
    private let streakView = JournalStatsBadgeView()

    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 8
        stackView.distribution = .equalSpacing

        [totalRecordsView, perDayRecordsView, streakView].forEach { stackView.addArrangedSubview($0) }

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 32),
            widthAnchor.constraint(equalToConstant: 364),

            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func updateLabels(totalRecords: String, perDayRecords: String, streakDays: String) {
        totalRecordsView.setText(totalRecords)
        perDayRecordsView.setText(perDayRecords)
        streakView.setText(streakDays)
    }
}

final class JournalStatsBadgeView: UIView {
    
    private let label = UILabel()

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = UIColor.darkGray
        layer.cornerRadius = 16
        clipsToBounds = true

        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        addSubview(label)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 32),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

    func setText(_ text: String) {
        label.text = text
    }
}
