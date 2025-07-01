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

    private static var maxDateWidth: NSLayoutConstraint?
    private static var maxEmotionWidth: NSLayoutConstraint?

    private static var maxIconsWidth: CGFloat = 0
    private var iconsWidthConstraint: NSLayoutConstraint?

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
        dateLabel.text = model.dateText

        iconsContainer.subviews.forEach { $0.removeFromSuperview() }

        emotionsLabel.text = model.emotionsNames.joined(separator: "\n")

        let maxIconsPerRow = 4
        let iconSize: CGFloat = 40
        let spacing: CGFloat = 4

        for (index, icon) in model.emotionsIcons.enumerated() {
            let imageView = UIImageView(image: icon)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            iconsContainer.addSubview(imageView)

            let row = index / maxIconsPerRow
            let column = index % maxIconsPerRow

            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: iconSize),
                imageView.heightAnchor.constraint(equalToConstant: iconSize),
                imageView.topAnchor.constraint(equalTo: iconsContainer.topAnchor,
                                               constant: CGFloat(row) * (iconSize + spacing)),
                imageView.trailingAnchor.constraint(equalTo: iconsContainer.trailingAnchor,
                                                    constant: -CGFloat(column) * (iconSize + spacing))
            ])
        }

        let totalColumns = min(maxIconsPerRow, model.emotionsIcons.count)
        let requiredWidth = CGFloat(totalColumns) * (iconSize + spacing) - (model.emotionsIcons.isEmpty ? 0 : spacing)

        if requiredWidth > Self.maxIconsWidth {
            Self.maxIconsWidth = requiredWidth
        }
        iconsWidthConstraint?.constant = Self.maxIconsWidth
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

        iconsContainer.translatesAutoresizingMaskIntoConstraints = false

        [dateLabel, emotionsLabel, iconsContainer].forEach {
            contentView.addSubview($0)
        }
    }

    private func setupConstraints() {
        dateLabel.setContentHuggingPriority(.required, for: .horizontal)
        dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        emotionsLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        emotionsLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        iconsContainer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        iconsContainer.setContentCompressionResistancePriority(.required, for: .horizontal)

        iconsWidthConstraint = iconsContainer.widthAnchor.constraint(equalToConstant: Self.maxIconsWidth)
        iconsWidthConstraint?.priority = .defaultHigh
        iconsWidthConstraint?.isActive = true

        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),
            dateLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),

            emotionsLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            emotionsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            emotionsLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 16),
            emotionsLabel.trailingAnchor.constraint(equalTo: iconsContainer.leadingAnchor, constant: -16),

            iconsContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            iconsContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            iconsContainer.leadingAnchor.constraint(greaterThanOrEqualTo: emotionsLabel.trailingAnchor, constant: 16),
            iconsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])

        if let anchor = Self.maxDateWidth?.firstItem as? NSLayoutDimension {
            dateLabel.widthAnchor.constraint(equalTo: anchor).isActive = true
        }
        if let anchor = Self.maxEmotionWidth?.firstItem as? NSLayoutDimension {
            emotionsLabel.widthAnchor.constraint(equalTo: anchor).isActive = true
        }
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
