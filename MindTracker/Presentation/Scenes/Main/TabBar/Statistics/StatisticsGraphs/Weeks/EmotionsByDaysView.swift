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
//        tableView.estimatedRowHeight = 66

        addSubview(tableView)
    }

    private func setupConstraints() {
        tableHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 66 * 7)
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

        let rowCount = max(days.count, 7)
        tableHeightConstraint?.constant = CGFloat(rowCount) * 66

        tableView.reloadData()
        setNeedsLayout()
        layoutIfNeeded()
    }
}

extension EmotionsByDaysView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        max(days.count, 7)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row >= days.count {
            let cell = UITableViewCell()
            let placeholder = UIImageView(image: AppIcons.emotionPlaceholder)
            placeholder.contentMode = .scaleAspectFit
            placeholder.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(placeholder)
            NSLayoutConstraint.activate([
                placeholder.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                placeholder.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                placeholder.heightAnchor.constraint(equalToConstant: 40)
            ])
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        }

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
