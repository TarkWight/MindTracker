//
//  EmotionCardView.swift
//  MindTracker
//
//  Created by Tark Wight on 28.02.2025.
//

import UIKit

final class EmotionCardView: UIView {
    
    private let timeLabel = UILabel()
    private let feelingLabel = UILabel()
    private let emotionLabel = UILabel()
    private let emotionIcon = UIImageView()
    private let gradientOverlay = UIView()
    
    var onTap: (() -> Void)?
    
    init(emotion: EmotionCardModel) {
        super.init(frame: .zero)
        setupUI()
        configure(with: emotion)
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyRadialGradient(for: emotionLabel.textColor)
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 16
        clipsToBounds = true
        backgroundColor = UITheme.Colors.appGray
        
        gradientOverlay.translatesAutoresizingMaskIntoConstraints = false
        addSubview(gradientOverlay)

        timeLabel.font = UITheme.Font.EmotionCard.date
        timeLabel.textColor = UITheme.Colors.appWhite
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(timeLabel)

        feelingLabel.text = LocalizedKey.emotionCard
        feelingLabel.font = UITheme.Font.EmotionCard.label
        feelingLabel.textColor = UITheme.Colors.appWhite
        feelingLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(feelingLabel)

        emotionLabel.font = UITheme.Font.EmotionCard.title
        emotionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emotionLabel)

        emotionIcon.contentMode = .scaleAspectFit
        emotionIcon.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emotionIcon)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 158),

            gradientOverlay.topAnchor.constraint(equalTo: topAnchor),
            gradientOverlay.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientOverlay.bottomAnchor.constraint(equalTo: bottomAnchor),

            timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

            emotionIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            emotionIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            emotionIcon.widthAnchor.constraint(equalToConstant: 60),
            emotionIcon.heightAnchor.constraint(equalToConstant: 60),

            emotionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            emotionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            feelingLabel.bottomAnchor.constraint(equalTo: emotionLabel.topAnchor, constant: -4),
            feelingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }
    
    private func configure(with emotion: EmotionCardModel) {
        timeLabel.text = emotion.formattedDate
        emotionLabel.text = emotion.name
        emotionLabel.textColor = emotion.color
        emotionIcon.image = emotion.icon
        
        applyRadialGradient(for: emotion.color)
    }

    private func applyRadialGradient(for color: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            color.withAlphaComponent(0.4).cgColor,
            color.withAlphaComponent(0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 1.2, y: -0.2)
        gradientLayer.endPoint = CGPoint(x: -0.2, y: 2)

        gradientLayer.type = .radial

        gradientOverlay.layer.sublayers?.removeAll()
        gradientOverlay.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func cardTapped() {
        onTap?()
    }
}
