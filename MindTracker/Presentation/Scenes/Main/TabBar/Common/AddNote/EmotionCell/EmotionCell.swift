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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    private func setupUI() {
        contentView.layer.cornerRadius = 56
        contentView.layer.masksToBounds = true

        titleLabel.font = UITheme.Font.AddNote.emotionCell
        titleLabel.textColor = UITheme.Colors.appBlack
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, constant: -10)
        ])
    }

    func configure(with emotion: EmotionType) {
        contentView.backgroundColor = emotion.category.color
        titleLabel.text = emotion.name
    }
}
