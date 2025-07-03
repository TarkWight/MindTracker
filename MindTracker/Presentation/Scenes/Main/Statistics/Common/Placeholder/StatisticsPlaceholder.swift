//
//  StatisticsPlaceholder.swift
//  MindTracker
//
//  Created by Tark Wight on 02.07.2025.
//

import UIKit

final class StatisticsPlaceholder: UIView {

    private let messageLabel = UILabel()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupMessage()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupView() {
        backgroundColor = AppColors.background
    }

    private func setupMessage() {
        messageLabel.text = LocalizedKey.statisticsPlaceholder
        messageLabel.textColor = AppColors.appWhite
        messageLabel.textAlignment = .center
        messageLabel.font = Typography.header3alt
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupConstraints() {
        addSubview(messageLabel)

        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            messageLabel.leadingAnchor.constraint(
                greaterThanOrEqualTo: leadingAnchor,
                constant: 16
            ),
            messageLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: trailingAnchor,
                constant: -16
            ),
        ])
    }
}
