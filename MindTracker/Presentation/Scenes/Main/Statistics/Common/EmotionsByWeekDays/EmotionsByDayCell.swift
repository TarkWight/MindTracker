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
        dateLabel.text = model.dateText

        emotionsLabel.text = model.emotionsNames.joined(separator: "\n")

        iconsContainer.subviews.forEach { $0.removeFromSuperview() }

        layoutEmotionIcons(model.emotionsIcons)
    }

    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        dateLabel.font = Typography.bodySmallAlt
        dateLabel.textColor = AppColors.appWhite
        dateLabel.numberOfLines = 0
        dateLabel.adjustsFontSizeToFitWidth = false
        dateLabel.lineBreakMode = .byWordWrapping
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        emotionsLabel.font = Typography.bodySmallAlt
        emotionsLabel.textColor = AppColors.appGrayLighter
        emotionsLabel.numberOfLines = 0
        emotionsLabel.adjustsFontSizeToFitWidth = false
        emotionsLabel.lineBreakMode = .byWordWrapping
        emotionsLabel.setContentHuggingPriority(.required, for: .horizontal)
        emotionsLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
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
                constant: 0
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
        ])
    }

    private func layoutEmotionIcons(_ icons: [UIImage]) {
        iconsContainer.subviews.forEach { $0.removeFromSuperview() }

        let screenWidth = UIScreen.main.bounds.width
        let maxPerRow = screenWidth <= 375 ? 3 : 4
        let outerStack = UIStackView()
        outerStack.axis = .vertical
        outerStack.spacing = Constants.iconSpacing
        outerStack.alignment = .trailing
        outerStack.distribution = .fill
        outerStack.translatesAutoresizingMaskIntoConstraints = false

        let rowCount = Int(ceil(Double(icons.count) / Double(maxPerRow)))

        for rowIndex in 0..<rowCount {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = Constants.iconSpacing
            rowStack.alignment = .center
            rowStack.distribution = .fillProportionally

            let start = rowIndex * maxPerRow
            let end = min(start + maxPerRow, icons.count)

            for i in start..<end {
                let imageView = UIImageView(image: icons[i])
                imageView.contentMode = .scaleAspectFit
                imageView.layer.cornerRadius = Constants.iconSize / 2
                imageView.clipsToBounds = true
                imageView.translatesAutoresizingMaskIntoConstraints = false

                NSLayoutConstraint.activate([
                    imageView.widthAnchor.constraint(equalToConstant: Constants.iconSize),
                    imageView.heightAnchor.constraint(equalToConstant: Constants.iconSize)
                ])

                rowStack.addArrangedSubview(imageView)
            }

            outerStack.addArrangedSubview(rowStack)
        }

        iconsContainer.addSubview(outerStack)

        NSLayoutConstraint.activate([
            outerStack.topAnchor.constraint(equalTo: iconsContainer.topAnchor),
            outerStack.bottomAnchor.constraint(equalTo: iconsContainer.bottomAnchor),
            outerStack.leadingAnchor.constraint(greaterThanOrEqualTo: iconsContainer.leadingAnchor),
            outerStack.trailingAnchor.constraint(equalTo: iconsContainer.trailingAnchor)
        ])
    }
}

private enum Constants {
    static let minRowHeight: CGFloat = 64
    static let minStringBlockHeight: CGFloat = 40
    static let dateStackHeight: CGFloat = 32

    static let iconSize: CGFloat = 40
    static let iconSpacing: CGFloat = 4
}
