//
//  FrequentEmotionRowView.swift
//  MindTracker
//
//  Created by Tark Wight on 05.03.2025.
//

import UIKit

final class FrequentEmotionCell: UITableViewCell {

    static let reuseIdentifier = "FrequentEmotionCell"

    private let iconImageView = UIImageView()
    private let nameLabel = UILabel()
    private let countLabel = UILabel()
    private let progressBar = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.font = Typography.bodySmallAlt
        nameLabel.textColor = AppColors.appWhite
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        countLabel.font = Typography.bodySmall
        countLabel.textColor = AppColors.appBlack
        countLabel.translatesAutoresizingMaskIntoConstraints = false

        progressBar.layer.cornerRadius = 16
        progressBar.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(progressBar)
        contentView.addSubview(countLabel)
    }

    func configure(with emotion: EmotionType, count: Int, maxValue: Int) {
        iconImageView.image = emotion.icon
        nameLabel.text = emotion.name
        countLabel.text = "\(count)"

        progressBar.backgroundColor = emotion.category.color.withAlphaComponent(0.7)

        let barWidth = CGFloat(count) / CGFloat(maxValue) * 150
        progressBar.widthAnchor.constraint(equalToConstant: max(32, barWidth)).isActive = true
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            iconImageView.heightAnchor.constraint(equalToConstant: 32),

            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 4),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            progressBar.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 16),
            progressBar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 32),

            countLabel.leadingAnchor.constraint(equalTo: progressBar.leadingAnchor, constant: 16),
            countLabel.centerYAnchor.constraint(equalTo: progressBar.centerYAnchor),
            countLabel.trailingAnchor.constraint(lessThanOrEqualTo: progressBar.trailingAnchor, constant: -8),

            progressBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
