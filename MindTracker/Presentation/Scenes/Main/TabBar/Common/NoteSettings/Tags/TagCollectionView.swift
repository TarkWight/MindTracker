//
//  TagCollectionView.swift
//  MindTracker
//
//  Created by Tark Wight on 02.03.2025.
//

import UIKit

final class TagCollectionView: UIView {
    private var tags: [String] = []
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

    func setTags(_ newTags: [String]) {
        tags = newTags
        collectionView.reloadData()
    }
}

extension TagCollectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return tags.count + 1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    )
        -> UICollectionViewCell
    {
        if indexPath.item == tags.count {
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
                self.tags.append(tag)
                self.onTagsUpdated?(self.tags)
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
            let tagText = tags[indexPath.item]
            let isSelected = selectedTags.contains(tagText)
            cell.configure(with: tagText, isSelected: isSelected)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < tags.count else { return }
        let tag = tags[indexPath.item]
        if selectedTags.contains(tag) {
            selectedTags.remove(tag)
        } else {
            selectedTags.insert(tag)
        }
        collectionView.reloadItems(at: [indexPath])
    }

    func collectionView(
        _: UICollectionView,
        layout _: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    )
        -> CGSize
    {
        if indexPath.item == tags.count {
            return CGSize(width: 36, height: 36)
        } else {
            let text = tags[indexPath.item] as NSString
            let textSize = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 16, weight: .medium)])
            return CGSize(width: textSize.width + 32, height: 36)
        }
    }
}
