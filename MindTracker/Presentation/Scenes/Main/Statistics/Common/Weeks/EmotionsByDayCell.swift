//
//  EmotionsByDayCell.swift
//  MindTracker
//
//  Created by Tark Wight on 04.03.2025.
//

import UIKit

final class EmotionsByDayCell: UITableViewCell {

    static let reuseIdentifier = "EmotionsByDayCell"

    private let dateStack = UIStackView()
    private let dayOfWeekLabel = UILabel()
    private let shortDateLabel = UILabel()
    private let emotionsStack = UIStackView()
    private let iconsStack = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: EmotionDay) {
        let components = model.dateText.components(separatedBy: "\n")
        dayOfWeekLabel.text = components.first
        shortDateLabel.text = components.dropFirst().joined(separator: "\n")

        // Reset
        emotionsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        iconsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // Emotions
        for emotionName in model.emotionsNames {
            let label = UILabel()
            label.text = emotionName
            label.font = Typography.bodySmallAlt
            label.textColor = AppColors.appGrayLighter
            label.textAlignment = .center
            emotionsStack.addArrangedSubview(label)
        }

        // Icons
        for icon in model.emotionsIcons {
            let imageView = UIImageView(image: icon)
            imageView.contentMode = .scaleAspectFit
            imageView.layer.cornerRadius = AbobaLayout.iconSize / 2
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: AbobaLayout.iconSize),
                imageView.heightAnchor.constraint(equalToConstant: AbobaLayout.iconSize)
            ])
            iconsStack.addArrangedSubview(imageView)
        }
    }

    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        // Date stack
        dateStack.axis = .vertical
        dateStack.spacing = 2
        dateStack.alignment = .leading
        dayOfWeekLabel.font = Typography.bodySmallAlt
        dayOfWeekLabel.textColor = AppColors.appWhite
        shortDateLabel.font = Typography.bodySmallAlt
        shortDateLabel.textColor = AppColors.appWhite
        dateStack.addArrangedSubview(dayOfWeekLabel)
        dateStack.addArrangedSubview(shortDateLabel)

        // Emotion stack
        emotionsStack.axis = .vertical
        emotionsStack.spacing = 2
        emotionsStack.alignment = .center

        // Icons stack
        iconsStack.axis = .horizontal
        iconsStack.spacing = AbobaLayout.iconSpacing
        iconsStack.alignment = .center
        iconsStack.distribution = .fillProportionally

        [dateStack, emotionsStack, iconsStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dateStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            dateStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),
            dateStack.widthAnchor.constraint(equalToConstant: 70),

            emotionsStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emotionsStack.leadingAnchor.constraint(equalTo: dateStack.trailingAnchor, constant: 12),
            emotionsStack.trailingAnchor.constraint(lessThanOrEqualTo: iconsStack.leadingAnchor, constant: -12),

            iconsStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
}

// инжектнуть
enum AbobaLayout {
    static let minRowHeight: CGFloat = 64
    static let minStringBlockHeight: CGFloat = 40
    static let dateStackHeight: CGFloat = 32

    static let iconSize: CGFloat = 40
    static let iconSpacing: CGFloat = 4
}
