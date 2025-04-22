////
////  UIButton+Custom.swift
////  MindTracker
////
////  Created by Tark Wight on 21.02.2025.
////
//
//import UIKit
//
//extension UIButton {
//    private struct AssociatedKeys {
//        @MainActor static var iconImageView = "iconImageView"
//        @MainActor static var label = "label"
//        @MainActor static var config = "config"
//    }
//
//    private var iconImageView: UIImageView {
//        get {
//            if let imageView = objc_getAssociatedObject(self, &AssociatedKeys.iconImageView) as? UIImageView {
//                return imageView
//            }
//            let imageView = UIImageView()
//            imageView.isUserInteractionEnabled = true
//            objc_setAssociatedObject(self, &AssociatedKeys.iconImageView, imageView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//            return imageView
//        }
//    }
//
//    private var customLabel: UILabel {
//        get {
//            if let label = objc_getAssociatedObject(self, &AssociatedKeys.label) as? UILabel {
//                return label
//            }
//            let label = UILabel()
//            objc_setAssociatedObject(self, &AssociatedKeys.label, label, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//            return label
//        }
//    }
//
//    func configure(with config: ButtonConfiguration) {
//        addSubview(customLabel)
//        addSubview(iconImageView)
//
//        customLabel.translatesAutoresizingMaskIntoConstraints = false
//        iconImageView.translatesAutoresizingMaskIntoConstraints = false
//
//        customLabel.text = config.title
//        customLabel.textColor = config.textColor
//        customLabel.font = config.font.withSize(config.fontSize)
//        backgroundColor = config.backgroundColor
//        iconImageView.image = config.icon
//
//        layer.cornerRadius = config.cornerRadius
//
//        setupConstraints(config: config)
//
//        iconImageView.gestureRecognizers?.forEach { iconImageView.removeGestureRecognizer($0) }
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(iconTapped))
//        iconImageView.addGestureRecognizer(tapGesture)
//    }
//
//    private func setupConstraints(config: ButtonConfiguration) {
//        NSLayoutConstraint.deactivate(self.constraints)
//
//        NSLayoutConstraint.activate([
//            heightAnchor.constraint(equalToConstant: config.buttonHeight),
//        ])
//
//        if config.icon != nil {
//            switch config.iconPosition {
//            case .left:
//                NSLayoutConstraint.activate([
//                    iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: config.padding),
//                    iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
//                    iconImageView.widthAnchor.constraint(equalToConstant: config.iconSize),
//                    iconImageView.heightAnchor.constraint(equalToConstant: config.iconSize),
//
//                    customLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
//                    customLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
//                    customLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -config.padding),
//                ])
//            case .right:
//                NSLayoutConstraint.activate([
//                    customLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
//                    customLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
//
//                    iconImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -config.padding),
//                    iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
//                    iconImageView.widthAnchor.constraint(equalToConstant: config.iconSize),
//                    iconImageView.heightAnchor.constraint(equalToConstant: config.iconSize),
//                ])
//            }
//        } else {
//            NSLayoutConstraint.activate([
//                customLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
//                customLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
//                customLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: config.padding),
//                customLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -config.padding),
//            ])
//        }
//    }
//
//    @objc private func iconTapped() {
//        sendActions(for: .touchUpInside)
//    }
//}
