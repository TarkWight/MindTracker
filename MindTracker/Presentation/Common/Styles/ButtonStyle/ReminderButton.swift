//
//  ReminderButton.swift
//  MindTracker
//
//  Created by Tark Wight on 04.03.2025.
//

import UIKit

final class ReminderButtonView: UIButton {
    var onDeleteTapped: ((String) -> Void)?

    init(time: String) {
        super.init(frame: .zero)
        setupView(time: time)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView(time: String) {
        setTitle(time, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        backgroundColor = .darkGray
        layer.cornerRadius = 20
        clipsToBounds = true

        contentHorizontalAlignment = .left
        contentEdgeInsets = UIEdgeInsets(top: 18, left: 16, bottom: 18, right: 56)

        let deleteButton = UIButton(type: .system)
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.tintColor = .white
        deleteButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        deleteButton.layer.cornerRadius = 24
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)

        addSubview(deleteButton)

        NSLayoutConstraint.activate([
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            deleteButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 48),
            deleteButton.heightAnchor.constraint(equalToConstant: 48),
        ])
    }

    @objc private func deleteTapped() {
        guard let reminderText = title(for: .normal) else { return }
        onDeleteTapped?(reminderText)
    }
}
