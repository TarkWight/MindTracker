//
//  WeekFilterCollectionViewCell.swift
//  MindTracker
//
//  Created by Tark Wight on 03.03.2025.
//


import UIKit

final class WeekFilterCollectionViewCell: UICollectionViewCell {
    static let identifier = "WeekFilterCollectionViewCell"

    private let label: UILabel = {
        let label = UILabel()
        label.font = UITheme.Font.StatisticsScene.weekCell
        label.textColor = UITheme.Colors.appWhite
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        updateAppearance()

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    func configure(with text: String, isSelected: Bool) {
        label.text = text
        self.isSelected = isSelected
        updateAppearance()
    }

    private func updateAppearance() {
        contentView.backgroundColor = isSelected ? UITheme.Colors.appWhite : .clear
        label.textColor = isSelected ? .black : UITheme.Colors.appWhite
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: label.intrinsicContentSize.width + 16, height: 48)
    }
}
