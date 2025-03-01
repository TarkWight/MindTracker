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
    
    init(emotion: EmotionModel) {
        super.init(frame: .zero)
        setupUI()
        configure(with: emotion)
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 16
        clipsToBounds = true
        
        // Градиентный фильтр
        gradientOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        gradientOverlay.translatesAutoresizingMaskIntoConstraints = false
        addSubview(gradientOverlay)

        // Время
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        timeLabel.textColor = .white
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(timeLabel)

        // Надпись "Я чувствую"
        feelingLabel.text = "Я чувствую"
        feelingLabel.font = UIFont.systemFont(ofSize: 16)
        feelingLabel.textColor = .white
        feelingLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(feelingLabel)

        // Эмоция (основной текст)
        emotionLabel.font = UIFont.boldSystemFont(ofSize: 20)
        emotionLabel.textColor = .white
        emotionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emotionLabel)

        // Иконка эмоции
        emotionIcon.contentMode = .scaleAspectFit
        emotionIcon.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emotionIcon)

        // Constraints
        NSLayoutConstraint.activate([
            // Размеры карточки
            widthAnchor.constraint(equalToConstant: 364),
            heightAnchor.constraint(equalToConstant: 158),
            
            // Градиент поверх всей карточки
            gradientOverlay.topAnchor.constraint(equalTo: topAnchor),
            gradientOverlay.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientOverlay.bottomAnchor.constraint(equalTo: bottomAnchor),

            // Время (дата)
            timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            // "Я чувствую"
            feelingLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 8),
            feelingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            // Название эмоции
            emotionLabel.topAnchor.constraint(equalTo: feelingLabel.bottomAnchor, constant: 4),
            emotionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            emotionLabel.trailingAnchor.constraint(lessThanOrEqualTo: emotionIcon.leadingAnchor, constant: -16),
            
            // Иконка эмоции
            emotionIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            emotionIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            emotionIcon.widthAnchor.constraint(equalToConstant: 60),
            emotionIcon.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func configure(with emotion: EmotionModel) {
        timeLabel.text = emotion.time
        emotionLabel.text = emotion.name
        backgroundColor = emotion.color
        emotionIcon.image = emotion.icon
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func cardTapped() {
        onTap?()
    }
}

// Модель эмоции
struct EmotionModel {
    let name: String
    let time: String
    let color: UIColor
    let icon: UIImage?
}
