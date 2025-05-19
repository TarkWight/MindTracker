//
//  EmotionsByDayCell.swift
//  MindTracker
//
//  Created by Tark Wight on 04.03.2025.
//

import UIKit

final class EmotionsByDayCell: UITableViewCell {

    static let reuseIdentifier = "EmotionsByDayCell"

    private let dateLabel = UILabel()
    private let emotionsLabel = UILabel()
    private let iconsStackView = UIStackView()
    private let placeholderView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    func configure(with model: EmotionDay) {
        dateLabel.text = model.day + "\n" + model.date

        let isEmpty = model.emotions.isEmpty
        emotionsLabel.isHidden = isEmpty
        iconsStackView.isHidden = isEmpty
        placeholderView.isHidden = !isEmpty

        if isEmpty { return }

        emotionsLabel.text = model.emotions.map { $0.type.name }.joined(separator: "\n")

        iconsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for emotion in model.emotions {
            let imageView = UIImageView(image: emotion.type.icon)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            iconsStackView.addArrangedSubview(imageView)
        }
    }

    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        selectionStyle = .none

        dateLabel.font = Typography.bodySmallAlt
        dateLabel.textColor = AppColors.appWhite
        dateLabel.numberOfLines = 2
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        emotionsLabel.font = Typography.bodySmallAlt
        emotionsLabel.textColor = AppColors.appGrayLighter
        emotionsLabel.numberOfLines = 0
        emotionsLabel.translatesAutoresizingMaskIntoConstraints = false

        iconsStackView.axis = .horizontal
        iconsStackView.spacing = 4
        iconsStackView.alignment = .trailing
        iconsStackView.translatesAutoresizingMaskIntoConstraints = false

        placeholderView.image = AppIcons.emotionPlaceholder
        placeholderView.contentMode = .scaleAspectFit
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.isHidden = true

        [dateLabel, emotionsLabel, iconsStackView, placeholderView].forEach {
            contentView.addSubview($0)
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            emotionsLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emotionsLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 16),
            emotionsLabel.trailingAnchor.constraint(equalTo: iconsStackView.leadingAnchor, constant: -16),

            iconsStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            placeholderView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            placeholderView.heightAnchor.constraint(equalToConstant: 40),
            placeholderView.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
}
enum AbobaLayout {
    static let minRowHeight: CGFloat = 64
    static let minStringBlockHeight: CGFloat = 40
    static let dateStackHeight: CGFloat = 32

    static let iconSize: CGFloat = 40
    static let iconSpacing: CGFloat = 4
}
