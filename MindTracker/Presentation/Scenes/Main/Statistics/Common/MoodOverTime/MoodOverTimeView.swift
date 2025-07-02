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
    private let columnMaxHeight: CGFloat =
        UIScreen.main.bounds.height * 0.6 - 58

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
            chartView.heightAnchor.constraint(
                equalToConstant: UIScreen.main.bounds.height * 0.6
            ),
        ])
    }

    func configure(with columns: [MoodColumnData]) {
        chartView.subviews.forEach { $0.removeFromSuperview() }

        let slotCount = columns.count
        let columnWidth =
            (bounds.width - spacing * CGFloat(slotCount - 1))
            / CGFloat(slotCount)

        for (index, column) in columns.enumerated() {
            let container = createColumnContainer(at: index, width: columnWidth)
            if column.total == 0 {
                addEmptyBar(to: container)
            } else {
                addEmotionBars(
                    to: container,
                    emotions: column.emotions,
                    total: column.total,
                    width: columnWidth
                )
            }
            addTimeLabel(column.label, below: container)
        }
    }

    private func createColumnContainer(at index: Int, width: CGFloat) -> UIView {
        let container = UIView()
        chartView.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: chartView.topAnchor),
            container.leadingAnchor.constraint(
                equalTo: chartView.leadingAnchor,
                constant: CGFloat(index) * (width + spacing)
            ),
            container.widthAnchor.constraint(equalToConstant: width),
            container.heightAnchor.constraint(equalToConstant: columnMaxHeight),
        ])

        return container
    }

    private func addEmptyBar(to container: UIView) {
        let bar = UIView()
        bar.backgroundColor = AppColors.appGray
        bar.layer.cornerRadius = 8
        bar.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(bar)

        NSLayoutConstraint.activate([
            bar.topAnchor.constraint(equalTo: container.topAnchor),
            bar.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            bar.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            bar.trailingAnchor.constraint(equalTo: container.trailingAnchor),
        ])
    }

    private func addEmotionBars(
        to container: UIView,
        emotions: [EmotionType: Int],
        total: Int,
        width: CGFloat
    ) {
        var currentY: CGFloat = 0
        let sorted = emotions.sorted { $0.value > $1.value }

        for (emotion, count) in sorted {
            let percent = CGFloat(count) / CGFloat(total)
            let height = percent * columnMaxHeight

            let barView = UIView()
            barView.layer.cornerRadius = 8
            barView.clipsToBounds = true
            container.addSubview(barView)
            barView.translatesAutoresizingMaskIntoConstraints = false

            let gradient = CAGradientLayer()
            let colors = emotion.category.gradientColors
            gradient.colors = [colors[0], colors[1]]
            gradient.startPoint = CGPoint(x: 0.5, y: 0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1)
            gradient.cornerRadius = 8
            gradient.frame = CGRect(x: 0, y: 0, width: width, height: height)
            barView.layer.insertSublayer(gradient, at: 0)

            NSLayoutConstraint.activate([
                barView.topAnchor.constraint(
                    equalTo: container.topAnchor,
                    constant: currentY
                ),
                barView.leadingAnchor.constraint(
                    equalTo: container.leadingAnchor
                ),
                barView.trailingAnchor.constraint(
                    equalTo: container.trailingAnchor
                ),
                barView.heightAnchor.constraint(equalToConstant: height),
            ])

            addPercentLabel(to: barView, percent: percent)

            currentY += height + 2
        }
    }

    private func addPercentLabel(to view: UIView, percent: CGFloat) {
        let label = UILabel()
        label.text = "\(Int(percent * 100))%"
        label.font = Typography.bodySmallAltBold
        label.textColor = AppColors.appBlack
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    private func addTimeLabel(_ text: String, below container: UIView) {
        let label = TopAlignedLabel()
        label.text = text.replacingOccurrences(of: " ", with: "\n")
        label.font = Typography.bodySmall
        label.textColor = AppColors.appWhite
        label.textAlignment = .center
        label.contentMode = .top
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        chartView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(
                equalTo: container.bottomAnchor,
                constant: 16
            ),
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            label.widthAnchor.constraint(
                lessThanOrEqualTo: container.widthAnchor
            ),
            label.heightAnchor.constraint(equalToConstant: labelHeight),
        ])
    }
}
