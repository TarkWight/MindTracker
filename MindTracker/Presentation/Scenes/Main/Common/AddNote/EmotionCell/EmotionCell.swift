//
//  EmotionCell.swift
//  MindTracker
//
//  Created by Tark Wight on 01.03.2025.
//

import UIKit

final class EmotionCell: UICollectionViewCell {
    static let identifier = "EmotionCell"

    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = contentView.bounds.width / 2
    }

    private func setupUI() {
        contentView.layer.masksToBounds = true

        titleLabel.font = Typography.caption
        titleLabel.textColor = AppColors.appBlack
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1

        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, constant: -10),
        ])
    }

    func configure(with emotion: EmotionType) {
        contentView.backgroundColor = emotion.category.color
        titleLabel.text = emotion.name
    }

    func setSelected(_ selected: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.contentView.transform = selected
                ? CGAffineTransform(scaleX: 1.25, y: 1.25)
                : .identity
        }
    }
}
