//
//  MoodOverTimeView.swift
//  MindTracker
//
//  Created by Tark Wight on 21.05.2025.
//

import UIKit

final class MoodOverTimeView: UIView {

    private let chartView = UIView()
    private let spacing: CGFloat = 8
    private let labelHeight: CGFloat = 58
    private let columnMaxHeight: CGFloat = UIScreen.main.bounds.height * 0.6 - 58

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear

        addSubview(chartView)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: topAnchor),
            chartView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: trailingAnchor),
            chartView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.6)
        ])
    }

    func configure(with columns: [MoodColumnData]) { // Function Body Length Violation: Function body should span 80 lines or less excluding comments and whitespace: currently spans 82 lines (function_body_length)
        chartView.subviews.forEach { $0.removeFromSuperview() }

        let slotCount = columns.count
        let columnWidth = (bounds.width - spacing * CGFloat(slotCount - 1)) / CGFloat(slotCount)

        for (index, column) in columns.enumerated() {
            let columnContainer = UIView()
            chartView.addSubview(columnContainer)
            columnContainer.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                columnContainer.topAnchor.constraint(equalTo: chartView.topAnchor),
                columnContainer.leadingAnchor.constraint(equalTo: chartView.leadingAnchor, constant: CGFloat(index) * (columnWidth + spacing)),
                columnContainer.widthAnchor.constraint(equalToConstant: columnWidth),
                columnContainer.heightAnchor.constraint(equalToConstant: columnMaxHeight)
            ])

            if column.total == 0 {
                let emptyBar = UIView()
                emptyBar.backgroundColor = AppColors.appGray
                emptyBar.layer.cornerRadius = 4
                emptyBar.translatesAutoresizingMaskIntoConstraints = false
                columnContainer.addSubview(emptyBar)
                NSLayoutConstraint.activate([
                    emptyBar.topAnchor.constraint(equalTo: columnContainer.topAnchor),
                    emptyBar.bottomAnchor.constraint(equalTo: columnContainer.bottomAnchor),
                    emptyBar.leadingAnchor.constraint(equalTo: columnContainer.leadingAnchor),
                    emptyBar.trailingAnchor.constraint(equalTo: columnContainer.trailingAnchor)
                ])
            } else {
                var currentY: CGFloat = 0
                let sortedEmotions = column.emotions.sorted { $0.value > $1.value }

                for (emotion, count) in sortedEmotions {
                    let percent = CGFloat(count) / CGFloat(column.total)
                    let barHeight = percent * columnMaxHeight

                    let barView = UIView()
                    barView.layer.cornerRadius = 4
                    barView.clipsToBounds = true
                    columnContainer.addSubview(barView)
                    barView.translatesAutoresizingMaskIntoConstraints = false

                    let colors = emotion.category.gradientColors
                    let gradient = CAGradientLayer()
                    gradient.colors = [colors[0], colors[1]]
                    gradient.startPoint = CGPoint(x: 0.5, y: 0)
                    gradient.endPoint = CGPoint(x: 0.5, y: 1)
                    gradient.cornerRadius = 4
                    gradient.frame = CGRect(x: 0, y: 0, width: columnWidth, height: barHeight)

                    barView.layer.insertSublayer(gradient, at: 0)

                    NSLayoutConstraint.activate([
                        barView.topAnchor.constraint(equalTo: columnContainer.topAnchor, constant: currentY),
                        barView.leadingAnchor.constraint(equalTo: columnContainer.leadingAnchor),
                        barView.trailingAnchor.constraint(equalTo: columnContainer.trailingAnchor),
                        barView.heightAnchor.constraint(equalToConstant: barHeight)
                    ])

                    let label = UILabel()
                    label.text = "\(Int(percent * 100))%"
                    label.font = Typography.bodySmallAltBold
                    label.textColor = AppColors.appBlack
                    label.textAlignment = .center
                    label.adjustsFontSizeToFitWidth = true
                    label.minimumScaleFactor = 0.7
                    label.translatesAutoresizingMaskIntoConstraints = false
                    barView.addSubview(label)

                    NSLayoutConstraint.activate([
                        label.centerXAnchor.constraint(equalTo: barView.centerXAnchor),
                        label.centerYAnchor.constraint(equalTo: barView.centerYAnchor)
                    ])

                    currentY += barHeight + 2
                }
            }

            let timeLabel = UILabel()
            timeLabel.text = column.label
            timeLabel.font = Typography.bodySmall
            timeLabel.textColor = AppColors.appWhite
            timeLabel.textAlignment = .center
            timeLabel.numberOfLines = 0
            timeLabel.adjustsFontSizeToFitWidth = true
            timeLabel.minimumScaleFactor = 0.8
            chartView.addSubview(timeLabel)
            timeLabel.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                timeLabel.topAnchor.constraint(equalTo: columnContainer.bottomAnchor, constant: 4),
                timeLabel.centerXAnchor.constraint(equalTo: columnContainer.centerXAnchor),
                timeLabel.heightAnchor.constraint(equalToConstant: labelHeight)
            ])
        }
    }
}
