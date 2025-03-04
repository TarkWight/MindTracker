//
//  WeekFilterView.swift
//  MindTracker
//
//  Created by Tark Wight on 03.03.2025.
//

import UIKit

final class WeekFilterView: UIView {
    private var weeks: [DateInterval] = []
    var selectedWeek: DateInterval?
    var onWeekSelected: ((DateInterval) -> Void)?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            WeekFilterCollectionViewCell.self,
            forCellWithReuseIdentifier: WeekFilterCollectionViewCell.identifier
        )
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    init(weeks: [DateInterval], selectedWeek: DateInterval) {
        self.weeks = weeks
        self.selectedWeek = selectedWeek
        super.init(frame: .zero)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    private func setupUI() {
        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    func updateWeeks(_ newWeeks: [DateInterval], selected: DateInterval) {
        weeks = newWeeks
        selectedWeek = selected
        collectionView.reloadData()
    }
}

extension WeekFilterView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return weeks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell
    {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WeekFilterCollectionViewCell.identifier,
                for: indexPath
            ) as? WeekFilterCollectionViewCell
        else {
            return UICollectionViewCell()
        }

        let week = weeks[indexPath.item]
        let weekText = formatWeekText(from: week)

        cell.configure(with: weekText, isSelected: week == selectedWeek)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedWeek = weeks[indexPath.item]
        onWeekSelected?(weeks[indexPath.item])
        collectionView.reloadData()
    }

    private func formatWeekText(from week: DateInterval) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        let startDay = formatter.string(from: week.start)
        let endDay = formatter.string(from: week.end)

        formatter.dateFormat = "MMM"
        let month = formatter.string(from: week.start)

        return "\(startDay)–\(endDay) \(month)"
    }
}
