//
//  ConfirmButton.swift
//  MindTracker
//
//  Created by Tark Wight on 01.03.2025.
//

import UIKit

final class ConfirmButton: UIButton {
    private let label = UILabel()
    private let iconBackground = UIView()
    private let icon: UIImageView = {
        let imageView = UIImageView(image: AppIcons.arrowRight?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = AppColors.appWhite
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var selectedEmotion: EmotionType?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        updateState(for: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        layer.cornerRadius = 40
        backgroundColor = AppColors.appGrayFaded
        isEnabled = false

        label.font = Typography.bodySmallAlt
        label.textColor = AppColors.appWhite
        label.textAlignment = .left
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping

        iconBackground.layer.cornerRadius = 32
        iconBackground.backgroundColor = AppColors.appGrayLight
        iconBackground.translatesAutoresizingMaskIntoConstraints = false
        iconBackground.isUserInteractionEnabled = false

        icon.tintColor = AppColors.appWhite
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.isUserInteractionEnabled = false

        addSubview(label)
        addSubview(iconBackground)
        iconBackground.addSubview(icon)

        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 80),

            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(lessThanOrEqualTo: iconBackground.leadingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            label.widthAnchor.constraint(lessThanOrEqualToConstant: 252),

            iconBackground.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            iconBackground.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconBackground.widthAnchor.constraint(equalToConstant: 64),
            iconBackground.heightAnchor.constraint(equalToConstant: 64),

            icon.centerXAnchor.constraint(equalTo: iconBackground.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: iconBackground.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 32),
            icon.heightAnchor.constraint(equalToConstant: 32),
        ])
    }

    func updateState(for emotion: EmotionType?) {
        selectedEmotion = emotion

        if let emotion = emotion {
            let title = emotion.name
            let description = emotion.description

            let fullText = "\(title)\n\(description)"
            let attributedText = NSMutableAttributedString(string: fullText)

            let emotionColor = emotion.category.color
            let titleRange = (fullText as NSString).range(of: title)
            attributedText.addAttribute(.foregroundColor, value: emotionColor, range: titleRange)

            label.attributedText = attributedText
            backgroundColor = AppColors.appGrayFaded

            isEnabled = true
            iconBackground.backgroundColor = AppColors.appWhite
            icon.tintColor = AppColors.appBlack
        } else {
            label.text = LocalizedKey.addNoteConfirmButton
            label.textColor = AppColors.appWhite
            backgroundColor = AppColors.appGrayFaded

            isEnabled = false
            iconBackground.backgroundColor = AppColors.appGrayLight
            icon.tintColor = AppColors.appWhite
        }
    }
}
