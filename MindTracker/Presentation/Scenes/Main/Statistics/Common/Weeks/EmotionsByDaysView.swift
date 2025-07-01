//
//  EmotionsByDaysView.swift
//  MindTracker
//
//  Created by Tark Wight on 04.03.2025.
//

import UIKit

final class EmotionsByDaysView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedKey.statisticsEmotionsByDays
        label.font = Typography.header1
        label.textColor = AppColors.appWhite
        label.numberOfLines = 2
        return label
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = AppColors.appGray
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.alwaysBounceVertical = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.isScrollEnabled = false
        return tableView
    }()

    private var days: [EmotionDay] = []
    private var tableHeightConstraint: NSLayoutConstraint?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
    }

    // MARK: - Setup

    private func setupUI() {
        backgroundColor = .clear

        tableView.register(EmotionsByDayCell.self, forCellReuseIdentifier: EmotionsByDayCell.reuseIdentifier)
        tableView.dataSource = self

        addSubview(titleLabel)
        addSubview(tableView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupConstraints() {
        tableHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 400)
        tableHeightConstraint?.priority = .required
        tableHeightConstraint?.isActive = true

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    // MARK: - Public

    func update(with days: [EmotionDay]) {
        self.days = days
        tableView.reloadData()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.adjustHeightBasedOnContent()
        }
    }

    private func adjustHeightBasedOnContent() {
        tableView.layoutIfNeeded()

        let numberOfRows = tableView.numberOfRows(inSection: 0)
        var totalHeight: CGFloat = 0

        for i in 0..<numberOfRows {
            let indexPath = IndexPath(row: i, section: 0)
            totalHeight += tableView.rectForRow(at: indexPath).height
        }

        // + extra space for separators and layout margins
        totalHeight += 30
        tableHeightConstraint?.constant = totalHeight
        layoutIfNeeded()
    }
}

// MARK: - UITableViewDataSource

extension EmotionsByDaysView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        days.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EmotionsByDayCell.reuseIdentifier, for: indexPath) as? EmotionsByDayCell else {
            return UITableViewCell()
        }

        cell.configure(with: days[indexPath.row])
        return cell
    }
}
