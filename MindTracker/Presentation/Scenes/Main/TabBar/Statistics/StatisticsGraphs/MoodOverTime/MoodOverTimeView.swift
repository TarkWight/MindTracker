//
//  MoodOverTimeView.swift
//  MindTracker
//
//  Created by Tark Wight on 21.05.2025.
//

import Foundation
import UIKit

@MainActor
final class MoodOverTimeView: UIView {

    private var stackView = UIStackView()
    private var data: [[EmotionType]] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    private func setupView() {
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func configure(with data: [[EmotionType]]) {
        self.data = data
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for emotions in data {
            let cell = MoodTimeZoneCell()
            cell.configure(with: emotions)
            stackView.addArrangedSubview(cell)
        }
    }
}

final class MoodTimeZoneCell: UIView {

    private let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    private func setupView() {
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func configure(with emotions: [EmotionType]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let totalHeight = UIScreen.main.bounds.height * (454.0 / 892.0)

        if emotions.isEmpty {
            let barContainer = UIView()
            barContainer.translatesAutoresizingMaskIntoConstraints = false

            let bar = UIView()
            bar.backgroundColor = AppColors.appGray
            bar.layer.cornerRadius = 4
            bar.translatesAutoresizingMaskIntoConstraints = false

            barContainer.addSubview(bar)
            NSLayoutConstraint.activate([
                bar.topAnchor.constraint(equalTo: barContainer.topAnchor),
                bar.bottomAnchor.constraint(equalTo: barContainer.bottomAnchor),
                bar.leadingAnchor.constraint(equalTo: barContainer.leadingAnchor),
                bar.trailingAnchor.constraint(equalTo: barContainer.trailingAnchor),
                bar.heightAnchor.constraint(equalTo: barContainer.heightAnchor)
            ])

            NSLayoutConstraint.activate([
                barContainer.heightAnchor.constraint(equalToConstant: totalHeight)
            ])

            stackView.addArrangedSubview(barContainer)
            return
        }

        let total = emotions.count
        let singleHeight = totalHeight / CGFloat(total)

        for emotion in emotions {
            let barContainer = UIView()
            barContainer.translatesAutoresizingMaskIntoConstraints = false

            let bar = UIView()
            let color = emotion.category.color
            bar.backgroundColor = (color == .clear) ? AppColors.appGray : color
            bar.layer.cornerRadius = 4
            bar.translatesAutoresizingMaskIntoConstraints = false

            let percentLabel = UILabel()
            percentLabel.text = "\(100 / total)%"
            percentLabel.textColor = .white
            percentLabel.font = .systemFont(ofSize: 10)
            percentLabel.textAlignment = .center
            percentLabel.translatesAutoresizingMaskIntoConstraints = false

            bar.addSubview(percentLabel)
            NSLayoutConstraint.activate([
                percentLabel.centerXAnchor.constraint(equalTo: bar.centerXAnchor),
                percentLabel.centerYAnchor.constraint(equalTo: bar.centerYAnchor)
            ])

            barContainer.addSubview(bar)
            NSLayoutConstraint.activate([
                bar.topAnchor.constraint(equalTo: barContainer.topAnchor),
                bar.bottomAnchor.constraint(equalTo: barContainer.bottomAnchor),
                bar.leadingAnchor.constraint(equalTo: barContainer.leadingAnchor),
                bar.trailingAnchor.constraint(equalTo: barContainer.trailingAnchor),
                bar.heightAnchor.constraint(equalTo: barContainer.heightAnchor)
            ])

            NSLayoutConstraint.activate([
                barContainer.heightAnchor.constraint(equalToConstant: singleHeight)
            ])

            stackView.addArrangedSubview(barContainer)
        }
    }
}
