//
//  EmotionsOverviewView.swift
//  MindTracker
//
//  Created by Tark Wight on 03.03.2025.
//

import UIKit

final class EmotionsOverviewView: UIView {
    private let titleLabel = UILabel()
    private let recordsLabel = UILabel()
    private let chartView = GroupedEmotionsChartView()

    init(title: String, recordsCount: Int, data: [EmotionCategory: Int]) {
        super.init(frame: .zero)
        setupUI(title: title, recordsCount: recordsCount)
        configure(with: data)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    private func setupUI(title: String, recordsCount: Int) {
        titleLabel.text = title
        titleLabel.font = UITheme.Font.StatisticsScene.title
        titleLabel.textColor = UITheme.Colors.appWhite
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        recordsLabel.text = String(format: LocalizedKey.Statistics.records, recordsCount)
        recordsLabel.font = UITheme.Font.StatisticsScene.categorySubtitle
        recordsLabel.textColor = UITheme.Colors.appWhite.withAlphaComponent(0.7)
        recordsLabel.translatesAutoresizingMaskIntoConstraints = false

        chartView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabel)
        addSubview(recordsLabel)
        addSubview(chartView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 72),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),

            recordsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            recordsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            recordsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),

            chartView.topAnchor.constraint(equalTo: recordsLabel.bottomAnchor, constant: 24),
            chartView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            chartView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),

            chartView.heightAnchor.constraint(equalTo: chartView.widthAnchor, multiplier: 0.9),

            chartView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
        ])
    }

    override var intrinsicContentSize: CGSize {
        let chartHeight = bounds.width * 0.9
        let totalHeight = 124 + titleLabel.intrinsicContentSize.height + 8 +
                          recordsLabel.intrinsicContentSize.height + 24 +
                          chartHeight + 24
        return CGSize(width: UIView.noIntrinsicMetric, height: totalHeight)
    }

    func configure(with data: [EmotionCategory: Int]) {
        chartView.configure(with: data)
        invalidateIntrinsicContentSize()  
    }

    func updateRecordsCount(_ count: Int) {
        recordsLabel.text = String(format: LocalizedKey.Statistics.records, count)
    }
}
