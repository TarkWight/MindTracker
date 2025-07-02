//
//  WeekFilterView.swift
//  MindTracker
//
//  Created by Tark Wight on 03.03.2025.
//

import UIKit

final class WeekFilterView: UIView, UICollectionViewDelegate,
    UICollectionViewDataSource {
    private var weeks: [DateInterval] = []
    var selectedWeek: DateInterval?
    var onWeekSelected: ((DateInterval) -> Void)?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            WeekFilterCollectionViewCell.self,
            forCellWithReuseIdentifier: WeekFilterCollectionViewCell.identifier
        )
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.bounces = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
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
            collectionView.heightAnchor.constraint(equalToConstant: 48),
        ])
    }

    func updateWeeks(_ newWeeks: [DateInterval], selected: DateInterval) {
        let previousSelected = selectedWeek
        weeks = newWeeks
        selectedWeek = selected

        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
        scrollToSelectedWeek()

        if let index = weeks.firstIndex(of: selected),
            previousSelected == selected {
            let indexPath = IndexPath(item: index, section: 0)
            collectionView.selectItem(
                at: indexPath,
                animated: false,
                scrollPosition: []
            )
            collectionView.delegate?.collectionView?(
                collectionView,
                didSelectItemAt: indexPath
            )
        }
    }

    private func scrollToSelectedWeek() {
        guard let selectedWeek = selectedWeek,
            let index = weeks.firstIndex(of: selectedWeek)
        else { return }
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int)
        -> Int {
        return weeks.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
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

    // MARK: - UICollectionViewDelegate

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let newlySelectedWeek = weeks[indexPath.item]

        guard newlySelectedWeek != selectedWeek else {
            if let cell = collectionView.cellForItem(at: indexPath)
                as? WeekFilterCollectionViewCell {
                cell.configure(
                    with: formatWeekText(from: newlySelectedWeek),
                    isSelected: true
                )
            }
            return
        }

        selectedWeek = newlySelectedWeek
        onWeekSelected?(newlySelectedWeek)
        collectionView.reloadData()
    }

    private func formatWeekText(from week: DateInterval) -> String {
        let startDate = DateFormatter.formattedMonth(from: week.start)
        let endDate = DateFormatter.formattedMonth(from: week.end)

        let startComponents = startDate.split(separator: " ")
        let endComponents = endDate.split(separator: " ")

        let startDay = startComponents[0]
        let startMonth = startComponents[1]

        let endDay = endComponents[0]
        let endMonth = endComponents[1]

        return startMonth == endMonth
            ? "\(startDay)–\(endDay) \(startMonth)"
            : "\(startDay) \(startMonth) – \(endDay) \(endMonth)"
    }
}
