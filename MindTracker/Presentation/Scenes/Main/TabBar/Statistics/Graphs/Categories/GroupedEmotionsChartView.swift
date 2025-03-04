//
//  GroupedEmotionsChartView.swift
//  MindTracker
//
//  Created by Tark Wight on 03.03.2025.
//


import UIKit

final class GroupedEmotionsChartView: UIView {
    private var emotionGroups: [(color: UIColor, percentage: CGFloat)] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    func configure(with data: [EmotionCategory: Int]) {
        let filteredData = data.filter { $0.key.localizedName != EmotionType.placeholder.name }

        let total = CGFloat(filteredData.values.reduce(0, +))
        guard total > 0 else {
            emotionGroups = []
            setNeedsDisplay()
            return
        }

        let rawPercentages = filteredData.map { (category, count) -> (UIColor, CGFloat) in
            return (category.color, CGFloat(count) / total * 100)
        }

        var roundedPercentages = rawPercentages.map { ($0.0, floor($0.1)) }
        let totalRounded = roundedPercentages.reduce(0) { $0 + $1.1 }
        let missingPercentage = 100 - totalRounded

        for i in 0..<Int(missingPercentage) {
            roundedPercentages[i].1 += 2
        }

        emotionGroups = roundedPercentages.map { ($0.0, $0.1 / 100) }

        setNeedsDisplay()
    }
       
    
    override func draw(_ rect: CGRect) {
        guard !emotionGroups.isEmpty else { return }

        let width = bounds.width
        let height = bounds.height
        let maxRadius = min(width, height) / 2.5
        let minRadius = maxRadius * 0.5

        let sortedGroups = emotionGroups.sorted { $0.percentage > $1.percentage }

        var circles: [(center: CGPoint, radius: CGFloat, color: UIColor)] = []

        let positions = generatePositions(count: sortedGroups.count, width: width, height: height)

        for (index, (color, percentage)) in sortedGroups.enumerated() {
            guard index < positions.count else { break }

            let radius = minRadius + (maxRadius - minRadius) * percentage
            let circleCenter = positions[index]

            circles.append((circleCenter, radius, color))
        }

        let context = UIGraphicsGetCurrentContext()
        circles.reversed().forEach { drawCircle(context: context, circle: $0, minRadius: minRadius, maxRadius: maxRadius) }
    }

    private func drawCircle(context: CGContext?, circle: (center: CGPoint, radius: CGFloat, color: UIColor), minRadius: CGFloat, maxRadius: CGFloat) {
        context?.setFillColor(circle.color.cgColor)
        context?.addEllipse(in: CGRect(
            x: circle.center.x - circle.radius,
            y: circle.center.y - circle.radius,
            width: circle.radius * 2,
            height: circle.radius * 2
        ))
        context?.fillPath()

        let percentageText = "\(Int((circle.radius - minRadius) / (maxRadius - minRadius) * 100))%"
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UITheme.Font.SettingsScene.categoryPersent,
            .foregroundColor: UITheme.Colors.appBlack
        ]
        let textSize = percentageText.size(withAttributes: textAttributes)
        let textRect = CGRect(
            x: circle.center.x - textSize.width / 2,
            y: circle.center.y - textSize.height / 2,
            width: textSize.width,
            height: textSize.height
        )
        percentageText.draw(in: textRect, withAttributes: textAttributes)
    }

    private func generatePositions(count: Int, width: CGFloat, height: CGFloat) -> [CGPoint] {
        var positions: [CGPoint] = []

        let centerX = width / 2
        let centerY = height / 2
        let radius = min(width, height) / 3

        if count == 1 {
            positions.append(CGPoint(x: centerX, y: centerY))
        } else {
            for i in 0..<count {
                let angle = CGFloat(i) * (2 * .pi / CGFloat(count))
                let x = centerX + radius * cos(angle)
                let y = centerY + radius * sin(angle)
                positions.append(CGPoint(x: x, y: y))
            }
        }

        return positions
    }
}

private extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return hypot(x - point.x, y - point.y)
    }
}
