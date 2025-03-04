//
//  EmotionsByDaysView.swift
//  MindTracker
//
//  Created by Tark Wight on 04.03.2025.
//


import UIKit

final class EmotionsByDaysView: UIView {
    private let titleLabel = UILabel()
    private let stackView = UIStackView()

    private var viewModel: StatisticsViewModel

    init(viewModel: StatisticsViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
        setupBindings()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    private func setupUI() {
        titleLabel.text = viewModel.emotionsByDaysTitle
        titleLabel.font = UITheme.Font.StatisticsScene.title
        titleLabel.textColor = UITheme.Colors.appWhite
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabel)
        addSubview(stackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupBindings() {
        viewModel.onDaysUpdated = { [weak self] days in
            self?.updateData(with: days)
        }
    }

    private func updateData(with days: [EmotionDayModel]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for day in days {
            let rowView = EmotionsByDayRowView(dayData: day)
            stackView.addArrangedSubview(rowView)
        }
    }
}
