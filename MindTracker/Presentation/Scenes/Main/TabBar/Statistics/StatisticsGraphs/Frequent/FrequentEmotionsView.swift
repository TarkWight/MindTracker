//
//  FrequentEmotionsView.swift
//  MindTracker
//
//  Created by Tark Wight on 05.03.2025.
//

import UIKit

@MainActor
final class FrequentEmotionsView: UIView {
    private let stackView = UIStackView()
    private let placeholderLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override var intrinsicContentSize: CGSize {
        let stackHeight = stackView.arrangedSubviews.reduce(0) { $0 + $1.intrinsicContentSize.height + stackView.spacing }
        let minHeight: CGFloat = 120
        return CGSize(width: UIView.noIntrinsicMetric, height: max(stackHeight, minHeight))
    }

    private func setupUI() {

        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        placeholderLabel.text = LocalizedKey.statisticsNoFrequentEmotions
        placeholderLabel.font = Typography.header4
        placeholderLabel.textColor = AppColors.appGrayLighter
        placeholderLabel.textAlignment = .center
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.isHidden = true

        addSubview(stackView)
        addSubview(placeholderLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

            placeholderLabel.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),

            bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 24),
        ])
    }

    func configure(with data: [EmotionType: Int]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        guard !data.isEmpty else {
            placeholderLabel.isHidden = false
            invalidateIntrinsicContentSize()
            return
        }

        placeholderLabel.isHidden = true

        let sortedData = data.sorted { $0.value > $1.value }
        let maxValue = sortedData.first?.value ?? 1

        for (emotion, count) in sortedData {
            let row = FrequentEmotionRowView(emotion: emotion, count: count, maxValue: maxValue)
            stackView.addArrangedSubview(row)
        }

        invalidateIntrinsicContentSize()
    }
}
