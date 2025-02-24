//
//  CustomButton.swift
//  MindTracker
//
//  Created by Tark Wight on 21.02.2025.
//


import UIKit

class CustomButton: UIButton {
    
    private let iconImageView = UIImageView()
    private let label = UILabel()
    
    private var buttonHeight: CGFloat = 50
    private var cornerRadius: CGFloat = 20
    private var padding: CGFloat = 16
    private var iconSize: CGFloat = 24
    
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

        layer.cornerRadius = config.cornerRadius
        setupConstraints(config.icon != nil)
    }
    
    private func setupConstraints(_ hasIcon: Bool) {
        NSLayoutConstraint.deactivate(self.constraints)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: buttonHeight)
        ])

        if hasIcon {
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
                label.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: padding),
                label.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -padding)
            ])
        }
    }
}
