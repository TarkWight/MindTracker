//
//  FrequentEmotionsView.swift
//  MindTracker
//
//  Created by Tark Wight on 05.03.2025.
//

import UIKit

@MainActor
final class FrequentEmotionsView: UIView {

    private let tableView = UITableView()
    private var tableHeightConstraint: NSLayoutConstraint?

    private var data: [(EmotionType, Int)] = []
    private var maxValue: Int = 1

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    private func setupUI() {
        tableView.register(FrequentEmotionCell.self, forCellReuseIdentifier: FrequentEmotionCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.separatorInset = .zero
        tableView.isScrollEnabled = true
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(tableView)
    }

    private func setupConstraints() {
        let heightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint.priority = .defaultHigh
        tableHeightConstraint = heightConstraint

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            heightConstraint
        ])
    }

    func configure(with data: [EmotionType: Int]) {
        let sorted = data.sorted { $0.value > $1.value }
        self.data = sorted
        self.maxValue = sorted.first?.value ?? 1

        let rowHeight: CGFloat = 32
        let rowSpacing: CGFloat = 8
        let totalHeight = CGFloat(data.count) * rowHeight + CGFloat(max(0, data.count - 1)) * rowSpacing
        tableHeightConstraint?.constant = totalHeight

        tableView.reloadData()
    }
}

extension FrequentEmotionsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: FrequentEmotionCell.reuseIdentifier, for: indexPath) as? FrequentEmotionCell
        else {
            return UITableViewCell()
        }

        let (emotion, count) = data[indexPath.row]
        cell.configure(with: emotion, count: count, maxValue: maxValue)
        return cell
    }
}

// MARK: - FrequentEmotionCell

final class FrequentEmotionCell: UITableViewCell {

    static let reuseIdentifier = "FrequentEmotionCell"

    private let iconImageView = UIImageView()
    private let nameLabel = UILabel()
    private let countLabel = UILabel()
    private let progressBar = UIView()
    private var progressWidthConstraint: NSLayoutConstraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.font = Typography.bodySmallAlt
        nameLabel.textColor = AppColors.appWhite
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        countLabel.font = Typography.bodySmall
        countLabel.textColor = AppColors.appBlack
        countLabel.translatesAutoresizingMaskIntoConstraints = false

        progressBar.layer.cornerRadius = 16
        progressBar.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(progressBar)
        contentView.addSubview(countLabel)
    }

    func configure(with emotion: EmotionType, count: Int, maxValue: Int) {
        iconImageView.image = emotion.icon
        nameLabel.text = emotion.name
        countLabel.text = "\(count)"

        progressBar.backgroundColor = emotion.category.color.withAlphaComponent(0.7)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            iconImageView.heightAnchor.constraint(equalToConstant: 32),

            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 4),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: progressBar.leadingAnchor, constant: -16),

            progressBar.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 16),
            progressBar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            countLabel.leadingAnchor.constraint(equalTo: progressBar.leadingAnchor, constant: 16),
            countLabel.centerYAnchor.constraint(equalTo: progressBar.centerYAnchor),
            countLabel.trailingAnchor.constraint(lessThanOrEqualTo: progressBar.trailingAnchor, constant: -8),

            progressBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            iconImageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 12),
            progressBar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}
