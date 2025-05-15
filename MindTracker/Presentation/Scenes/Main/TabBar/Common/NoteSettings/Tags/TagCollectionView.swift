//
//  TagCollectionView.swift
//  MindTracker
//
//  Created by Tark Wight on 02.03.2025.
//

import UIKit

final class TagCollectionView: UIView {
    private var availableTags: [String] = []
    private var selectedTags: Set<String> = []

    private let collectionView: UICollectionView

    var onTagsUpdated: (([String]) -> Void)?

    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .vertical

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(frame: frame)

        setupCollectionView()
    }

    override var intrinsicContentSize: CGSize {
        collectionView.layoutIfNeeded()
        return collectionView.contentSize
    }

    required init?(coder _: NSCoder) {
        return nil
    }

    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.identifier)
        collectionView.register(TagInputCell.self, forCellWithReuseIdentifier: TagInputCell.identifier)

        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 36),
        ])
    }

    func setAvailableTags(_ tags: [String]) {
        availableTags = Array(Set(tags)).sorted()
        collectionView.reloadData()
    }

    func setTags(_ tags: [String]) {
        selectedTags = Set(tags)
        collectionView.reloadData()
    }

    func getSelectedTags() -> [String] {
        Array(selectedTags)
    }
}

extension TagCollectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return availableTags.count + 1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if indexPath.item == availableTags.count {
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: TagInputCell.identifier,
                    for: indexPath
                ) as? TagInputCell
            else {
                return UICollectionViewCell()
            }
            cell.onTagAdded = { [weak self] tag in
                guard let self = self else { return }
                self.availableTags.append(tag)
                self.onTagsUpdated?(self.availableTags)
                self.collectionView.reloadData()
            }
            return cell
        } else {
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: TagCell.identifier,
                    for: indexPath
                ) as? TagCell
            else {
                return UICollectionViewCell()
            }
            let tagText = availableTags[indexPath.item]
            let isSelected = selectedTags.contains(tagText)
            cell.configure(with: tagText, isSelected: isSelected)
            return cell
        }
    }

    func collectionView(
        _: UICollectionView,
        layout _: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if indexPath.item == availableTags.count {
            return CGSize(width: 36, height: 36)
        } else {
            let text = availableTags[indexPath.item] as NSString
            let textSize = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 16, weight: .medium)])
            return CGSize(width: textSize.width + 32, height: 36)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < availableTags.count else { return }
        let tag = availableTags[indexPath.item]
        if selectedTags.contains(tag) {
            selectedTags.remove(tag)
        } else {
            selectedTags.insert(tag)
        }

        onTagsUpdated?(getSelectedTags())

        collectionView.reloadItems(at: [indexPath])
    }
}
