//
//  JournalStatsBadgeView.swift
//  MindTracker
//
//  Created by Tark Wight on 26.04.2025.
//

import UIKit

final class JournalStatsBadgeView: UIView {

    // MARK: - UI Elements

    private let label = UILabel()
    private var configuration: JournalStatsViewConfiguration

    // MARK: - Initializers

    init(configuration: JournalStatsViewConfiguration = .default) {
        self.configuration = configuration
        super.init(frame: .zero)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI

    private func setupUI() {
        backgroundColor = configuration.backgroundColor
        layer.cornerRadius = configuration.cornerRadius
        clipsToBounds = true

        label.textColor = configuration.textColor
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false

        addSubview(label)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: configuration.height),
            label.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: configuration.contentInsets.left
            ),
            label.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -configuration.contentInsets.right
            ),
            label.topAnchor.constraint(
                equalTo: topAnchor,
                constant: configuration.contentInsets.top
            ),
            label.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -configuration.contentInsets.bottom
            ),
        ])
    }

    // MARK: - Public Methods

    func setText(prefix: String?, value: String) {
        let attributedText = NSMutableAttributedString()

        if let prefix = prefix, !prefix.isEmpty,
            let prefixFont = configuration.prefixFont {
            let prefixAttributes: [NSAttributedString.Key: Any] = [
                .font: prefixFont,
                .foregroundColor: configuration.textColor,
            ]
            let prefixString = NSAttributedString(
                string: prefix,
                attributes: prefixAttributes
            )
            attributedText.append(prefixString)
        }

        let valueAttributes: [NSAttributedString.Key: Any] = [
            .font: configuration.valueFont,
            .foregroundColor: configuration.textColor,
        ]
        let valueString = NSAttributedString(
            string: value,
            attributes: valueAttributes
        )
        attributedText.append(valueString)

        label.attributedText = attributedText
    }
}
