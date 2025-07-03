//
//  FrequentEmotionsView.swift
//  MindTracker
//
//  Created by Tark Wight on 05.03.2025.
//

import UIKit

final class FrequentEmotionsView: UIView {

    private let tableView = UITableView()
    private var data: [(EmotionType, Int)] = []
    private var maxCount: Int = 1

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

        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.register(
            FrequentEmotionCell.self,
            forCellReuseIdentifier: FrequentEmotionCell.reuseIdentifier
        )
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            tableView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            tableView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -16
            ),
        ])
    }

    func configure(with input: [EmotionType: Int]) {
        let sorted = input.sorted { $0.value > $1.value }
        data = Array(sorted.prefix(5))
        maxCount = data.first.map { (_, count) in count } ?? 1
        tableView.reloadData()
    }
}

extension FrequentEmotionsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: FrequentEmotionCell.reuseIdentifier,
                for: indexPath
            ) as? FrequentEmotionCell
        else {
            return UITableViewCell()
        }

        let (emotion, count) = data[indexPath.row]
        cell.configure(
            with: emotion,
            count: count,
            maxCount: maxCount,
            totalWidth: tableView.bounds.width
        )
        return cell
    }
}
