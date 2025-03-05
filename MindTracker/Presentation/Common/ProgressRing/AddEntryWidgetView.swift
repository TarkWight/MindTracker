//
//  AddEntryWidgetView.swift
//  MindTracker
//
//  Created by Tark Wight on 28.02.2025.
//

import UIKit

final class AddEntryWidgetView: UIView {
    let progressRing = ProgressRingView()
    private let actionButton = UIButton()
    private let titleLabel = UILabel()

    var onTap: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(actionButton)
        addSubview(progressRing)
        addSubview(titleLabel)

        progressRing.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        actionButton.setImage(UIImage(named: "plusIcon"), for: .normal)
        actionButton.tintColor = UITheme.Colors.appWhite
        actionButton.backgroundColor = UITheme.Colors.appWhite
        actionButton.layer.cornerRadius = 32
        actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        titleLabel.textAlignment = .center
        titleLabel.textColor = UITheme.Colors.appWhite
        titleLabel.font = UITheme.Font.journalSceneAddNoteButton

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 364),
            heightAnchor.constraint(equalToConstant: 364),

            progressRing.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressRing.centerYAnchor.constraint(equalTo: centerYAnchor),
            progressRing.widthAnchor.constraint(equalTo: widthAnchor),
            progressRing.heightAnchor.constraint(equalTo: heightAnchor),

            actionButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            actionButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 64),
            actionButton.heightAnchor.constraint(equalToConstant: 64),

            titleLabel.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }

    @objc private func buttonTapped() {
        onTap?()
    }

    func setButtonTitle(_ title: String, textColor: UIColor, font: UIFont) {
        titleLabel.text = title
        titleLabel.textColor = textColor
        titleLabel.font = font
    }

    func setEmotionColors(_ colors: [UIColor]) {
        progressRing.setEmotionColors(colors)
    }
}
