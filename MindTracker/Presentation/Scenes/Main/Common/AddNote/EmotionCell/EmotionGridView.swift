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
    private var panGesture: UIPanGestureRecognizer!
    private var displayLink: CADisplayLink?

    private var initialCenter: CGPoint = .zero
    private var currentOffset: CGPoint = .zero
    private var targetOffset: CGPoint = .zero

    private var animationTargets: [IndexPath: CATransform3D] = [:]
    private var isAnimating = false

    private let scaleMultiplier: CGFloat = 1.5
    private let pushDistance: CGFloat = 20

    var onEmotionSelected: ((EmotionType) -> Void)?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        layout.itemSize = CGSize(width: 100, height: 100)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(EmotionCell.self, forCellWithReuseIdentifier: EmotionCell.identifier)
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
            collectionView.widthAnchor.constraint(equalToConstant: 500),
            collectionView.heightAnchor.constraint(equalToConstant: 500),
            collectionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)

        displayLink = CADisplayLink(target: self, selector: #selector(displayLinkTick))
        displayLink?.add(to: .main, forMode: .common)
        displayLink?.isPaused = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let topInset = safeAreaInsets.top + 20
        let bottomHeight: CGFloat = 80
        let extraSpacing: CGFloat = 40
        let bottomSpace = bottomHeight + extraSpacing + safeAreaInsets.bottom
        let availableHeight = bounds.height - topInset - bottomSpace
        let centerY = topInset + (availableHeight / 2)

        collectionView.center = CGPoint(x: bounds.midX, y: centerY)
        initialCenter = collectionView.center
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
            displayLink?.isPaused = true
            isAnimating = false
        }
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            targetOffset = CGPoint(
                x: collectionView.center.x - initialCenter.x,
                y: collectionView.center.y - initialCenter.y
            )
            currentOffset = targetOffset

        case .changed:
            let trans = gesture.translation(in: self)
            let damped = CGPoint(x: trans.x * 0.35, y: trans.y * 0.35)
            let newCenterX = initialCenter.x + currentOffset.x + damped.x
            let newCenterY = initialCenter.y + currentOffset.y + damped.y

            let maxXOffset: CGFloat = 250
            let maxYOffset: CGFloat = 300

            let limitedX = min(max(newCenterX, initialCenter.x - maxXOffset), initialCenter.x + maxXOffset)
            let limitedY = min(max(newCenterY, initialCenter.y - maxYOffset), initialCenter.y + maxYOffset)

            collectionView.center = CGPoint(x: limitedX, y: limitedY)
            targetOffset = CGPoint(x: limitedX - initialCenter.x, y: limitedY - initialCenter.y)
            currentOffset = targetOffset

            findAndSelectCenterCell(immediate: true)

        case .ended, .cancelled:
            targetOffset = CGPoint(
                x: collectionView.center.x - initialCenter.x,
                y: collectionView.center.y - initialCenter.y
            )
            currentOffset = targetOffset
            findAndSelectCenterCell(immediate: true)
        default:
            break
        }
    }

    private func findAndSelectCenterCell(immediate: Bool = false) {
        let point = convert(center, to: collectionView)
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

        let gridSize = 4
        let selectedRow = selected.item / gridSize
        let selectedCol = selected.item % gridSize

        for indexPath in collectionView.indexPathsForVisibleItems {
            let item = indexPath.item

            if indexPath == selected {
                animationTargets[indexPath] = CATransform3DMakeScale(scaleMultiplier, scaleMultiplier, 1.0)
            } else {
                let row = item / gridSize
                let col = item % gridSize
                let rowDiff = row - selectedRow
                let colDiff = col - selectedCol

                if rowDiff == 0 || colDiff == 0 {
                    let directionX: CGFloat = CGFloat(colDiff.signum())
                    let directionY: CGFloat = CGFloat(rowDiff.signum())
                    let distance = abs(rowDiff) + abs(colDiff)

                    let falloff: CGFloat = max(1.0 - CGFloat(distance) * 0.3, 0.2)
                    let offsetX = directionX * pushDistance * falloff
                    let offsetY = directionY * pushDistance * falloff

                    var transform = CATransform3DIdentity
                    transform = CATransform3DTranslate(transform, offsetX, offsetY, 0)
                    transform = CATransform3DScale(transform, 0.95, 0.95, 1.0)

                    animationTargets[indexPath] = transform
                } else {
                    animationTargets[indexPath] = CATransform3DIdentity
                }
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

extension EmotionGridView: UICollectionViewDataSource, UICollectionViewDelegate {
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
}
