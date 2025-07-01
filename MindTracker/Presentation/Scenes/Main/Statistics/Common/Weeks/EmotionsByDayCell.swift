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
    private let iconsContainer = UIView()

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
        // Дата
        dateLabel.text = model.dateText

        // Эмоции
        emotionsLabel.text = model.emotionsNames.joined(separator: "\n")

        // Очистить старые иконки
        iconsContainer.subviews.forEach { $0.removeFromSuperview() }

        // Добавить новые
        layoutEmotionIcons(model.emotionsIcons)
    }

    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        // Дата
        dateLabel.font = Typography.bodySmallAlt
        dateLabel.textColor = AppColors.appWhite
        dateLabel.numberOfLines = 0
        dateLabel.adjustsFontSizeToFitWidth = false
        dateLabel.lineBreakMode = .byWordWrapping
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        // Названия эмоций
        emotionsLabel.font = Typography.bodySmallAlt
        emotionsLabel.textColor = AppColors.appGrayLighter
        emotionsLabel.numberOfLines = 0
        emotionsLabel.adjustsFontSizeToFitWidth = false
        emotionsLabel.lineBreakMode = .byWordWrapping
        emotionsLabel.translatesAutoresizingMaskIntoConstraints = false

        iconsContainer.translatesAutoresizingMaskIntoConstraints = false

        [dateLabel, emotionsLabel, iconsContainer].forEach {
            contentView.addSubview($0)
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 12
            ),
            dateLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            dateLabel.widthAnchor.constraint(equalToConstant: 80),
            dateLabel.bottomAnchor.constraint(
                lessThanOrEqualTo: contentView.bottomAnchor,
                constant: -12
            ),

            emotionsLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 12
            ),
            emotionsLabel.leadingAnchor.constraint(
                equalTo: dateLabel.trailingAnchor,
                constant: 16
            ),
            emotionsLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: iconsContainer.leadingAnchor,
                constant: -16
            ),
            emotionsLabel.bottomAnchor.constraint(
                lessThanOrEqualTo: contentView.bottomAnchor,
                constant: -12
            ),

            iconsContainer.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 12
            ),
            iconsContainer.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),
            iconsContainer.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -12
            ),
            iconsContainer.widthAnchor.constraint(
                greaterThanOrEqualToConstant: AbobaLayout.iconSize * 4
                    + AbobaLayout.iconSpacing * 3
            ),
        ])
    }

    private func layoutEmotionIcons(_ icons: [UIImage]) {
        let maxPerRow = 4
        let rowCount = Int(ceil(Double(icons.count) / Double(maxPerRow)))

        let outerStack = UIStackView()
        outerStack.axis = .vertical
        outerStack.spacing = AbobaLayout.iconSpacing
        outerStack.alignment = .trailing
        outerStack.distribution = .fill
        outerStack.translatesAutoresizingMaskIntoConstraints = false

        for rowIndex in 0..<rowCount {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = AbobaLayout.iconSpacing
            rowStack.alignment = .center
            rowStack.distribution = .fillProportionally

            let start = rowIndex * maxPerRow
            let end = min(start + maxPerRow, icons.count)

            for i in start..<end {
                let imageView = UIImageView(image: icons[i])
                imageView.contentMode = .scaleAspectFit
                imageView.layer.cornerRadius = AbobaLayout.iconSize / 2
                imageView.clipsToBounds = true
                imageView.translatesAutoresizingMaskIntoConstraints = false

                NSLayoutConstraint.activate([
                    imageView.widthAnchor.constraint(
                        equalToConstant: AbobaLayout.iconSize
                    ),
                    imageView.heightAnchor.constraint(
                        equalToConstant: AbobaLayout.iconSize
                    ),
                ])

                rowStack.addArrangedSubview(imageView)
            }

            outerStack.addArrangedSubview(rowStack)
        }

        iconsContainer.addSubview(outerStack)

        NSLayoutConstraint.activate([
            outerStack.topAnchor.constraint(equalTo: iconsContainer.topAnchor),
            outerStack.bottomAnchor.constraint(
                equalTo: iconsContainer.bottomAnchor
            ),
            outerStack.leadingAnchor.constraint(
                greaterThanOrEqualTo: iconsContainer.leadingAnchor
            ),
            outerStack.trailingAnchor.constraint(
                equalTo: iconsContainer.trailingAnchor
            ),
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
