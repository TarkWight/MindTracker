//
//  FrequentEmotionCell.swift
//  MindTracker
//
//  Created by Tark Wight on 05.03.2025.
//

import UIKit

final class FrequentEmotionCell: UITableViewCell {

    static let reuseIdentifier = "FrequentEmotionCell"

    private var barWidthConstraint: NSLayoutConstraint?
    private var gradientLayer: CAGradientLayer?
    private let fixedBarStart: CGFloat = 180

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.bodySmallAlt
        label.textColor = AppColors.appWhite
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()

    private let barContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let progressBar: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.bodySmall
        label.textColor = AppColors.appBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(barContainer)
        barContainer.addSubview(progressBar)
        progressBar.addSubview(countLabel)

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            iconImageView.heightAnchor.constraint(equalToConstant: 32),

            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            barContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: fixedBarStart),
            barContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            barContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            barContainer.heightAnchor.constraint(equalToConstant: 36),

            progressBar.leadingAnchor.constraint(equalTo: barContainer.leadingAnchor),
            progressBar.topAnchor.constraint(equalTo: barContainer.topAnchor),
            progressBar.bottomAnchor.constraint(equalTo: barContainer.bottomAnchor),

            countLabel.leadingAnchor.constraint(equalTo: progressBar.leadingAnchor, constant: 12),
            countLabel.centerYAnchor.constraint(equalTo: progressBar.centerYAnchor),

            contentView.heightAnchor.constraint(equalToConstant: 44)
        ])

        barWidthConstraint = progressBar.widthAnchor.constraint(equalToConstant: 0)
        barWidthConstraint?.isActive = true
    }

    func configure(with emotion: EmotionType, count: Int, maxCount: Int, totalWidth: CGFloat) {
        iconImageView.image = emotion.icon
        nameLabel.text = emotion.name
        countLabel.text = "\(count)"

        layoutIfNeeded()

        let labelWidth = countLabel.intrinsicContentSize.width + 24
        let availableWidth = totalWidth - fixedBarStart - 8
        let maxBarWidth = max(labelWidth, availableWidth)

        let ratio = CGFloat(count) / CGFloat(max(maxCount, 1))
        let calculatedWidth = labelWidth + ratio * (maxBarWidth - labelWidth)

        barWidthConstraint?.constant = calculatedWidth

        gradientLayer?.removeFromSuperlayer()

        let gradient = CAGradientLayer()
        gradient.colors = [
            emotion.category.gradientEnd.cgColor,
            emotion.category.gradientStart.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = 16
        gradient.frame = CGRect(origin: .zero, size: CGSize(width: calculatedWidth, height: 36))

        progressBar.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
    }
}
