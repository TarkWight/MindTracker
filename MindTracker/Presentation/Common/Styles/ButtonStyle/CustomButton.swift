//
//  CustomButton.swift
//  MindTracker
//
//  Created by Tark Wight on 21.02.2025.
//


import UIKit

final class CustomButton: UIButton {
    
    private let iconImageView = UIImageView()
    private let label = UILabel()
    
    private var buttonHeight: CGFloat = 50
    private var cornerRadius: CGFloat = 20
    private var padding: CGFloat = 16
    private var iconSize: CGFloat = 24
    private var iconPosition: IconPosition = .left
    
    enum IconPosition {
        case left
        case right
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(label)
        addSubview(iconImageView)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        iconImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(iconTapped))
        iconImageView.addGestureRecognizer(tapGesture)
    }
    
    func configure(with config: ButtonConfiguration) {
        label.text = config.title
        label.textColor = config.textColor
        label.font = config.font.withSize(config.fontSize)
        self.backgroundColor = config.backgroundColor
        iconImageView.image = config.icon

        self.buttonHeight = config.buttonHeight
        self.cornerRadius = config.cornerRadius
        self.padding = config.padding
        self.iconSize = config.iconSize
        self.iconPosition = config.iconPosition

        layer.cornerRadius = config.cornerRadius
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.deactivate(self.constraints)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: buttonHeight)
        ])

        if let _ = iconImageView.image {
            if iconPosition == .left {
                NSLayoutConstraint.activate([
                    iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
                    iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                    iconImageView.widthAnchor.constraint(equalToConstant: iconSize),
                    iconImageView.heightAnchor.constraint(equalToConstant: iconSize),
                    
                    label.centerYAnchor.constraint(equalTo: centerYAnchor),
                    label.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
                    label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
                ])
            } else {
                NSLayoutConstraint.activate([
                    label.centerYAnchor.constraint(equalTo: centerYAnchor),
                    label.centerXAnchor.constraint(equalTo: centerXAnchor),
                    
                    iconImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
                    iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                    iconImageView.widthAnchor.constraint(equalToConstant: iconSize),
                    iconImageView.heightAnchor.constraint(equalToConstant: iconSize)
                ])
            }
        } else {
            NSLayoutConstraint.activate([
                label.centerYAnchor.constraint(equalTo: centerYAnchor),
                label.centerXAnchor.constraint(equalTo: centerXAnchor),
                label.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: padding),
                label.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -padding)
            ])
        }
    }
    
    @objc private func iconTapped() {
        sendActions(for: .touchUpInside)
    }
}
