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
