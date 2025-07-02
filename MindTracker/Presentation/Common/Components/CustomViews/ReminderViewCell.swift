//
//  ReminderViewCell.swift
//  MindTracker
//
//  Created by Tark Wight on 9.05.2025.
//

import UIKit

final class ReminderViewCell: UIView {

    // MARK: - Public Properties

    private(set) var id: UUID?

    var onTap: ((String, ReminderAction) -> Void)?
    var onButtonTap: ((UUID) -> Void)?

    // MARK: - UI Elements

    private let label = UILabel()
    private let button = UIButton()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        setupGesture()
        configureButtonIcon()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    // MARK: - Public API

    func setId(id: UUID) {
        self.id = id
    }

    func setupCell(label: String?) {
        self.label.text = label
    }

    func updateCell(label: String) {
        self.label.text = label
    }

    // MARK: - View Setup

    private func setupView() {
        backgroundColor = AppColors.appGrayFaded
        layer.cornerRadius = 28
        clipsToBounds = true

        label.font = Typography.header4
        label.textColor = AppColors.appWhite
        label.textAlignment = .left
        label.numberOfLines = 1

        button.backgroundColor = AppColors.appGrayLight
        button.layer.cornerRadius = 24
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(
            self,
            action: #selector(buttonTapped),
            for: .touchUpInside
        )

        addSubview(label)
        addSubview(button)

        label.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
            label.trailingAnchor.constraint(
                equalTo: button.leadingAnchor,
                constant: -16
            ),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 18),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18),
            label.heightAnchor.constraint(equalToConstant: 28),

            button.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -8
            ),
            button.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            button.widthAnchor.constraint(equalToConstant: 48),
            button.heightAnchor.constraint(equalToConstant: 48),
        ])
    }

    private func configureButtonIcon() {
        guard let icon = AppIcons.settingsDelete else { return }
        let renderedIcon = icon.withRenderingMode(.alwaysTemplate)
        button.setImage(renderedIcon, for: .normal)
        button.tintColor = AppColors.appWhite
    }

    // MARK: - Gestures

    private func setupGesture() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(viewTapped(_:))
        )
        addGestureRecognizer(tap)
    }

    @objc private func buttonTapped() {
        guard let id else { return }
        onButtonTap?(id)
    }

    @objc private func viewTapped(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        if !button.frame.contains(location),
            let labelText = label.text,
            let id = id {
            onTap?(labelText, .update(id))
        }
    }
}
