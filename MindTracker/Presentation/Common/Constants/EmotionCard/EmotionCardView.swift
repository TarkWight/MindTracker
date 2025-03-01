//
//  EmotionCardView.swift
//  MindTracker
//
//  Created by Tark Wight on 01.03.2025.
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
        layer.cornerRadius = 16
        clipsToBounds = true
        
        gradientOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        addSubview(gradientOverlay)
        gradientOverlay.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gradientOverlay.topAnchor.constraint(equalTo: topAnchor),
            gradientOverlay.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientOverlay.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        timeLabel.textColor = .white
        addSubview(timeLabel)
        
        feelingLabel.text = "Я чувствую"
        feelingLabel.font = UIFont.systemFont(ofSize: 16)
        feelingLabel.textColor = .white
        addSubview(feelingLabel)
        
        emotionLabel.font = UIFont.boldSystemFont(ofSize: 20)
        emotionLabel.textColor = .white
        addSubview(emotionLabel)
        
        emotionIcon.contentMode = .scaleAspectFit
        addSubview(emotionIcon)
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        feelingLabel.translatesAutoresizingMaskIntoConstraints = false
        emotionLabel.translatesAutoresizingMaskIntoConstraints = false
        emotionIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            feelingLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 8),
            feelingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            emotionLabel.topAnchor.constraint(equalTo: feelingLabel.bottomAnchor, constant: 4),
            emotionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            emotionIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            emotionIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            emotionIcon.widthAnchor.constraint(equalToConstant: 40),
            emotionIcon.heightAnchor.constraint(equalToConstant: 40)
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


struct EmotionModel {
    let name: String
    let time: String
    let color: UIColor
    let icon: UIImage
}
