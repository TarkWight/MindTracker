//
//  EmotionsByDayRowView.swift
//  MindTracker
//
//  Created by Tark Wight on 04.03.2025.
//

import UIKit

final class EmotionsByDayRowView: UIView {
    private let dayLabel = UILabel()
    private let dateLabel = UILabel()
    private let emotionsLabel = UILabel()
    private let iconsStackView = UIStackView()

    init(dayData: EmotionDayModel) {
        super.init(frame: .zero)
        setupUI(dayData: dayData)
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    private func setupUI(dayData: EmotionDayModel) {
        dayLabel.text = dayData.day
        dayLabel.font = Typography.bodySmallAlt
        dayLabel.textColor = AppColors.appWhite
        dayLabel.translatesAutoresizingMaskIntoConstraints = false

        dateLabel.text = dayData.date
        dateLabel.font = Typography.bodySmallAlt
        dateLabel.textColor = AppColors.appWhite.withAlphaComponent(0.7)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        emotionsLabel.text = dayData.emotions.map { $0.name }.joined(separator: "\n")
        emotionsLabel.font = Typography.bodySmallAlt
        emotionsLabel.textColor = AppColors.appWhite
        emotionsLabel.numberOfLines = 0
        emotionsLabel.translatesAutoresizingMaskIntoConstraints = false

        iconsStackView.axis = .horizontal
        iconsStackView.spacing = 8
        iconsStackView.alignment = .center
        iconsStackView.translatesAutoresizingMaskIntoConstraints = false

        for emotion in dayData.emotions {
            let imageView = UIImageView(image: emotion.icon)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
            iconsStackView.addArrangedSubview(imageView)
        }

        addSubview(dayLabel)
        addSubview(dateLabel)
        addSubview(emotionsLabel)
        addSubview(iconsStackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: topAnchor),
            dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor),

            dateLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 2),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor),

            emotionsLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            emotionsLabel.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: 16),
            emotionsLabel.trailingAnchor.constraint(equalTo: iconsStackView.leadingAnchor, constant: -16),

            iconsStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
