//
//  EmotionsByDaysView.swift
//  MindTracker
//
//  Created by Tark Wight on 04.03.2025.
//

import UIKit

@MainActor
final class EmotionsByDaysView: UIView {

    private let tableView = UITableView()
    private var days: [EmotionDay] = []
    private var tableHeightConstraint: NSLayoutConstraint?

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
        tableView.register(EmotionsByDayCell.self, forCellReuseIdentifier: EmotionsByDayCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.separatorInset = .zero
        tableView.separatorStyle = .singleLine
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 66

        addSubview(tableView)
    }

    private func setupConstraints() {
        tableHeightConstraint = tableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 66 * 7)
        tableHeightConstraint?.priority = .required

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ] + (tableHeightConstraint.map { [$0] } ?? []))
    }

    func update(with days: [EmotionDay]) {
        self.days = days

        let rowCount = days.count
        tableHeightConstraint?.constant = CGFloat(rowCount) * tableView.estimatedRowHeight

        tableView.reloadData()
    }
}

extension EmotionsByDaysView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        days.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: EmotionsByDayCell.reuseIdentifier,
            for: indexPath
        ) as? EmotionsByDayCell else {
            return UITableViewCell()
        }

        cell.configure(with: days[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}

final class EmotionsByDayCell: UITableViewCell {

    static let reuseIdentifier = "EmotionsByDayCell"

    private let dateLabel = UILabel()
    private let emotionsLabel = UILabel()
    private let iconsContainer = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    func configure(with model: EmotionDay) {
        dateLabel.text = model.dateText

        iconsContainer.subviews.forEach { $0.removeFromSuperview() }

        emotionsLabel.text = model.emotionsNames.joined(separator: "\n")

        let maxIconsPerRow = 4
        let iconSize: CGFloat = 40
        let spacing: CGFloat = 4

        for (index, icon) in model.emotionsIcons.enumerated() {
            let imageView = UIImageView(image: icon)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            iconsContainer.addSubview(imageView)

            let row = index / maxIconsPerRow
            let column = index % maxIconsPerRow

            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: iconSize),
                imageView.heightAnchor.constraint(equalToConstant: iconSize),
                imageView.topAnchor.constraint(equalTo: iconsContainer.topAnchor, constant: CGFloat(row) * (iconSize + spacing)),
                imageView.leadingAnchor.constraint(equalTo: iconsContainer.leadingAnchor, constant: CGFloat(column) * (iconSize + spacing))
            ])
        }
    }

    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        selectionStyle = .none

        dateLabel.font = Typography.bodySmallAlt
        dateLabel.textColor = AppColors.appWhite
        dateLabel.numberOfLines = 2
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        emotionsLabel.font = Typography.bodySmallAlt
        emotionsLabel.textColor = AppColors.appGrayLighter
        emotionsLabel.numberOfLines = 0
        emotionsLabel.translatesAutoresizingMaskIntoConstraints = false

        iconsContainer.translatesAutoresizingMaskIntoConstraints = false

        [dateLabel, emotionsLabel, iconsContainer].forEach {
            contentView.addSubview($0)
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),

            emotionsLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            emotionsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            emotionsLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 16),
            emotionsLabel.trailingAnchor.constraint(equalTo: iconsContainer.leadingAnchor, constant: -16),

            iconsContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            iconsContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            iconsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
enum AbobaLayout {
    static let minRowHeight: CGFloat = 64
    static let minStringBlockHeight: CGFloat = 40
    static let dateStackHeight: CGFloat = 32

    static let iconSize: CGFloat = 40
    static let iconSpacing: CGFloat = 4
}
