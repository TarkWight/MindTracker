//
//  JournalStatsView.swift
//  MindTracker
//
//  Created by Tark Wight on 28.02.2025.
//


import UIKit

final class JournalStatsView: UIView {
    
    private let stackView = UIStackView()
    private let totalRecordsLabel = UILabel()
    private let perDayRecordsLabel = UILabel()
    private let streakLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .darkGray
        layer.cornerRadius = 10
        clipsToBounds = true

        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8

        [totalRecordsLabel, perDayRecordsLabel, streakLabel].forEach { label in
            label.font = .systemFont(ofSize: 14, weight: .medium)
            label.textColor = .white
            stackView.addArrangedSubview(label)
        }

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 32),
            widthAnchor.constraint(equalToConstant: 364),

            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11.5),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -11.5),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

    func updateLabels(totalRecords: String, perDayRecords: String, streakDays: String) {
        totalRecordsLabel.text = totalRecords
        perDayRecordsLabel.text = perDayRecords
        streakLabel.text = streakDays
    }
}
