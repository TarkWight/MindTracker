//
//  TagCell.swift
//  MindTracker
//
//  Created by Tark Wight on 02.03.2025.
//

import UIKit

final class TagCell: UICollectionViewCell {
    static let identifier = "TagCell"

    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    private func setupUI() {
        contentView.layer.cornerRadius = 18
        contentView.layer.masksToBounds = true

        label.textColor = AppColors.appWhite
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center

        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    func configure(with text: String, isSelected: Bool) {
        label.text = text
        contentView.backgroundColor = isSelected ? AppColors.appGrayLight : AppColors.appGray
    }
}
