//
//  EmotionGridView.swift
//  MindTracker
//
//  Created by Tark Wight on 01.03.2025.
//

import UIKit

final class EmotionGridView: UIView {
    private let emotions: [EmotionType] = [
        .rage, .tension, .excitement, .delight, // r r y y
        .envy, .anxiety, .confidence, .happiness, // r r y y
        .burnout, .fatigue, .calmness, .satisfaction, // b b g g
        .depression, .apathy, .gratitude, .security, // b b g g
    ]

    private var selectedIndex: IndexPath?
    private var displayLink: CADisplayLink?
    private var animationTargets: [IndexPath: CATransform3D] = [:]
    private var isAnimating = false
    private var panGesture: UIPanGestureRecognizer!
    private var initialGridCenter: CGPoint = .zero
    private var currentGridOffset: CGPoint = .zero
    private var targetGridOffset: CGPoint = .zero

    private let scaleMultiplier: CGFloat = 1.35
//    private let pushDistance: CGFloat = 25
    private var pushDistance: CGFloat {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        else {
            return 20.0
        }
        let itemSize = CGFloat(layout.itemSize.width)
        let normalRadius = itemSize / 2
        let expandedRadius = normalRadius * scaleMultiplier
        return (expandedRadius - normalRadius) + 10.0
    }
    private let gridSize = 4

    var onEmotionSelected: ((EmotionType) -> Void)?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(EmotionCell.self, forCellWithReuseIdentifier: EmotionCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        clipsToBounds = false
        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: centerYAnchor),
            collectionView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),
            collectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.85)
        ])

        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.maximumNumberOfTouches = 1
        addGestureRecognizer(panGesture)

        displayLink = CADisplayLink(target: self, selector: #selector(displayLinkTick))
        displayLink?.add(to: .main, forMode: .common)
        displayLink?.isPaused = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        initialGridCenter = collectionView.center
        findAndSelectCenterCell()
    }

    @objc private func displayLinkTick() {
        guard isAnimating else { return }
        var allCompleted = true

        for (indexPath, target) in animationTargets {
            guard let cell = collectionView.cellForItem(at: indexPath) else { continue }
            let current = cell.layer.transform
            let updated = interpolate(from: current, to: target, step: 0.15)
            cell.layer.transform = updated
            if !transformEqual(updated, target) {
                allCompleted = false
            }
        }
        if allCompleted {
            isAnimating = false
            displayLink?.isPaused = true
        }
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            targetGridOffset = CGPoint(
                x: collectionView.center.x - initialGridCenter.x,
                y: collectionView.center.y - initialGridCenter.y
            )
            currentGridOffset = targetGridOffset
        case .changed:
            let translation = gesture.translation(in: self)
            let damped = CGPoint(x: translation.x * 0.35, y: translation.y * 0.35)

            var newCenter = CGPoint(
                x: initialGridCenter.x + currentGridOffset.x + damped.x,
                y: initialGridCenter.y + currentGridOffset.y + damped.y
            )

            let maxOffsetX = min(collectionView.bounds.width * 0.35, 250)
            let maxOffsetY = min(collectionView.bounds.height * 0.6, 300)

            newCenter.x = max(initialGridCenter.x - maxOffsetX, min(initialGridCenter.x + maxOffsetX, newCenter.x))
            newCenter.y = max(initialGridCenter.y - maxOffsetY, min(initialGridCenter.y + maxOffsetY, newCenter.y))

            collectionView.center = newCenter
            targetGridOffset = CGPoint(x: newCenter.x - initialGridCenter.x, y: newCenter.y - initialGridCenter.y)
            currentGridOffset = targetGridOffset
            findAndSelectCenterCell(immediate: true)
        case .ended, .cancelled:
            findAndSelectCenterCell(immediate: true)
        default:
            break
        }
    }

    private func findAndSelectCenterCell(immediate: Bool = false) {
        let screenCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        let point = collectionView.convert(screenCenter, from: self)

        var closestDist: CGFloat = .greatestFiniteMagnitude
        var closestIndex: IndexPath?

        for cell in collectionView.visibleCells {
            let dist = hypot(cell.center.x - point.x, cell.center.y - point.y)
            if dist < closestDist {
                closestDist = dist
                closestIndex = collectionView.indexPath(for: cell)
            }
        }

        guard let indexPath = closestIndex, indexPath != selectedIndex else { return }
        selectedIndex = indexPath
        onEmotionSelected?(emotions[indexPath.item])
        animateTransforms(selected: indexPath)
    }

    private func animateTransforms(selected: IndexPath) {
        animationTargets.removeAll()

        let selectedItem = selected.item
        let selectedRow = selectedItem / gridSize
        let selectedCol = selectedItem % gridSize

        for indexPath in collectionView.indexPathsForVisibleItems {
            let item = indexPath.item
            if indexPath == selected {
                animationTargets[indexPath] = CATransform3DMakeScale(scaleMultiplier, scaleMultiplier, 1.0)
                continue
            }

            let row = item / gridSize
            let col = item % gridSize
            let rowDiff = row - selectedRow
            let colDiff = col - selectedCol

            if rowDiff == 0 || colDiff == 0 {
                let dx = CGFloat(colDiff) * pushDistance
                let dy = CGFloat(rowDiff) * pushDistance
                var transform = CATransform3DMakeTranslation(dx, dy, 0)
                transform = CATransform3DScale(transform, 1.0, 1.0, 1.0)
                animationTargets[indexPath] = transform
            } else {
                animationTargets[indexPath] = CATransform3DIdentity
            }
        }

        isAnimating = true
        displayLink?.isPaused = false
    }

    private func interpolate(from: CATransform3D, to: CATransform3D, step: CGFloat) -> CATransform3D {
        let scale = from.m11 + (to.m11 - from.m11) * step
        let transformX = from.m41 + (to.m41 - from.m41) * step
        let transformY = from.m42 + (to.m42 - from.m42) * step
        var transform = CATransform3DMakeTranslation(transformX, transformY, 0)
        transform = CATransform3DScale(transform, scale, scale, 1.0)
        return transform
    }

    private func transformEqual(_ transformA: CATransform3D, _ transformB: CATransform3D) -> Bool {
        abs(transformA.m11 - transformB.m11) < 0.01 && abs(transformA.m41 - transformB.m41) < 0.01 && abs(transformA.m42 - transformB.m42) < 0.01
    }
}

extension EmotionGridView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        emotions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmotionCell.identifier, for: indexPath) as? EmotionCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: emotions[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing: CGFloat = 3 * 5 + 10
        let availableWidth = collectionView.bounds.width - totalSpacing
        let itemWidth = floor(availableWidth / CGFloat(gridSize))
        return CGSize(width: itemWidth, height: itemWidth)
    }
}
