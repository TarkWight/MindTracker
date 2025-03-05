//
//  FrequentEmotionsView.swift
//  MindTracker
//
//  Created by Tark Wight on 05.03.2025.
//

import UIKit

@MainActor
final class FrequentEmotionsView: UIView {
    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    private let placeholderLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    private func setupUI() {
        titleLabel.text = LocalizedKey.Statistics.frequentEmotions
        titleLabel.font = UITheme.Font.StatisticsScene.title
        titleLabel.textColor = UITheme.Colors.appWhite
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        placeholderLabel.text = LocalizedKey.Statistics.noFrequentEmotions
        placeholderLabel.font = UITheme.Font.StatisticsScene.categorySubtitle
        placeholderLabel.textColor = UITheme.Colors.appWhite.withAlphaComponent(0.5)
        placeholderLabel.textAlignment = .center
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.isHidden = true

        addSubview(titleLabel)
        addSubview(stackView)
        addSubview(placeholderLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            placeholderLabel.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
        ])
    }

    func configure(with data: [EmotionType: Int]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        guard !data.isEmpty else {
            placeholderLabel.isHidden = false
            return
        }

        placeholderLabel.isHidden = true

        let sortedData = data.sorted { $0.value > $1.value }
        let maxValue = sortedData.first?.value ?? 1

        for (emotion, count) in sortedData {
            let row = FrequentEmotionRowView(emotion: emotion, count: count, maxValue: maxValue)
            stackView.addArrangedSubview(row)
        }
    }
}
