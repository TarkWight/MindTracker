//
//  FrequentEmotionRowView.swift
//  MindTracker
//
//  Created by Tark Wight on 05.03.2025.
//

import UIKit

final class FrequentEmotionRowView: UIView {
    private let iconImageView = UIImageView()
    private let nameLabel = UILabel()
    private let countLabel = UILabel()
    private let progressBar = UIView()

    init(emotion: EmotionType, count: Int, maxValue: Int) {
        super.init(frame: .zero)
        setupUI(emotion: emotion, count: count, maxValue: maxValue)
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    private func setupUI(emotion: EmotionType, count: Int, maxValue: Int) {
        iconImageView.image = emotion.icon
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.text = emotion.name
        nameLabel.font = UITheme.Font.StatisticsScene.emotionTitle
        nameLabel.textColor = AppColors.appWhite
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        countLabel.text = "\(count)"
        countLabel.font = UITheme.Font.StatisticsScene.categoryPersent
        countLabel.textColor = AppColors.appBlack
        countLabel.translatesAutoresizingMaskIntoConstraints = false

        progressBar.backgroundColor = emotion.category.color.withAlphaComponent(0.7)
        progressBar.layer.cornerRadius = 16
        progressBar.translatesAutoresizingMaskIntoConstraints = false

        addSubview(iconImageView)
        addSubview(nameLabel)
        addSubview(progressBar)
        addSubview(countLabel)

        let barWidth = CGFloat(count) / CGFloat(maxValue) * 150
        progressBar.widthAnchor.constraint(equalToConstant: max(32, barWidth)).isActive = true
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            iconImageView.heightAnchor.constraint(equalToConstant: 32),

            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 4),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            progressBar.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 16),
            progressBar.centerYAnchor.constraint(equalTo: centerYAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 32),

            countLabel.leadingAnchor.constraint(equalTo: progressBar.leadingAnchor, constant: 16),
            countLabel.centerYAnchor.constraint(equalTo: progressBar.centerYAnchor),
            countLabel.trailingAnchor.constraint(lessThanOrEqualTo: progressBar.trailingAnchor, constant: -8),

            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
