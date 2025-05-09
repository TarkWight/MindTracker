//
//  WeekFilterCollectionViewCell.swift
//  MindTracker
//
//  Created by Tark Wight on 03.03.2025.
//

import UIKit

final class WeekFilterCollectionViewCell: UICollectionViewCell {
    static let identifier = "WeekFilterCollectionViewCell"

    private let weekLabel: UILabel = {
        let label = UILabel()
        label.font = UITheme.Font.StatisticsScene.weekCell
        label.textAlignment = .center
        label.textColor = UITheme.Colors.appWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let selectionIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = UITheme.Colors.appWhite
        view.layer.cornerRadius = 1.5
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    private func setupUI() {
        contentView.addSubview(weekLabel)
        contentView.addSubview(selectionIndicator)

        NSLayoutConstraint.activate([
            weekLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            weekLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            weekLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            weekLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),

            selectionIndicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            selectionIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            selectionIndicator.widthAnchor.constraint(equalToConstant: 73),
            selectionIndicator.heightAnchor.constraint(equalToConstant: 3),
        ])
    }

    func configure(with text: String, isSelected: Bool) {
        weekLabel.text = text
        selectionIndicator.isHidden = !isSelected
    }
}
