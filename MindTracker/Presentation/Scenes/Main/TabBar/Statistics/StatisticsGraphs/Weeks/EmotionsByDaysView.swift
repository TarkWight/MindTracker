//
//  EmotionsByDaysView.swift
//  MindTracker
//
//  Created by Tark Wight on 04.03.2025.
//

import UIKit

final class EmotionsByDaysView: UIView {
    private let titleLabel = UILabel()
    private let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override var intrinsicContentSize: CGSize {
        let totalHeight = max(
            568,
            stackView.arrangedSubviews.reduce(0) {
                $0 + $1.intrinsicContentSize.height + stackView.spacing
            }
        )

        return CGSize(width: UIView.noIntrinsicMetric, height: totalHeight)
    }

    private func setupUI() {
        titleLabel.text = LocalizedKey.statisticsEmotionsByDays
        titleLabel.font = Typography.header1
        titleLabel.textColor = AppColors.appWhite
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabel)
        addSubview(stackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }

    func update(with days: [EmotionDayModel]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for day in days {
            let filteredEmotions = day.emotions.filter { $0.type.name != EmotionType.placeholder.name }

            let rowView = EmotionsByDayRowView(dayData: EmotionDayModel(
                day: day.day,
                date: day.date,
                emotions: filteredEmotions.isEmpty ? day.emotions : filteredEmotions
            ))

            rowView.heightAnchor.constraint(greaterThanOrEqualToConstant: 64).isActive = true
            stackView.addArrangedSubview(rowView)
        }

        if days.isEmpty {
            let placeholderView = UIImageView(image: AppIcons.emotionPlaceholder)
            placeholderView.contentMode = .scaleAspectFit
            placeholderView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            stackView.addArrangedSubview(placeholderView)
        }

        setNeedsLayout()
        layoutIfNeeded()
    }
}
