//
//  GroupedEmotionsChartView.swift
//  MindTracker
//
//  Created by Tark Wight on 03.03.2025.
//
//
// import UIKit
//
// final class GroupedEmotionsChartView: UIView {
//    private var emotionGroups: [(color: UIColor, percentage: CGFloat)] = []
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = .clear
//    }
//
//    @available(*, unavailable)
//    required init?(coder _: NSCoder) {
//        fatalError("init(coder:) is not supported")
//    }
//
//    func configure(with data: [EmotionCategory: Int]) {
//        let filteredData = data.filter { $0.key.localizedName != EmotionType.placeholder.name }
//
//        let total = CGFloat(filteredData.values.reduce(0, +))
//        guard total > 0 else {
//            emotionGroups = []
//            setNeedsDisplay()
//            return
//        }
//
//        let rawPercentages = filteredData.map { category, count -> (UIColor, CGFloat) in
//            return (category.color, CGFloat(count) / total * 100)
//        }
//
//        var roundedPercentages = rawPercentages.map { ($0.0, floor($0.1)) }
//        let totalRounded = roundedPercentages.reduce(0) { $0 + $1.1 }
//        let missingPercentage = 100 - totalRounded
//
//        for index in 0 ..< Int(missingPercentage) {
//            roundedPercentages[index].1 += 2
//        }
//
//        emotionGroups = roundedPercentages.map { ($0.0, $0.1 / 100) }
//
//        setNeedsDisplay()
//    }
//
//    override func draw(_: CGRect) {
//        guard !emotionGroups.isEmpty else { return }
//
//        let width = bounds.width
//        let height = bounds.height
//        let maxRadius = min(width, height) / 2.5
//        let minRadius = maxRadius * 0.5
//
//        let sortedGroups = emotionGroups.sorted { $0.percentage > $1.percentage }
//
//        var circles: [
//            (
//                center: CGPoint,
//                radius: CGFloat,
//                color: UIColor
//            )
//        ] = []
//
//        let positions = generatePositions(count: sortedGroups.count, width: width, height: height)
//
//        for (index, (color, percentage)) in sortedGroups.enumerated() {
//            guard index < positions.count else { break }
//
//            let radius = minRadius + (maxRadius - minRadius) * percentage
//            let circleCenter = positions[index]
//
//            circles.append((circleCenter, radius, color))
//        }
//
//        let context = UIGraphicsGetCurrentContext()
//        for item in circles.reversed() {
//            drawCircle(
//                context: context,
//                circle: item,
//                minRadius: minRadius,
//                maxRadius: maxRadius
//            )
//        }
//    }
//
//    private func drawCircle(
//        context: CGContext?,
//        circle:
//        (
//            center: CGPoint,
//            radius: CGFloat,
//            color: UIColor
//        ),
//        minRadius: CGFloat, maxRadius: CGFloat
//    ) {
//        context?.setFillColor(circle.color.cgColor)
//        context?.addEllipse(in: CGRect(
//            x: circle.center.x - circle.radius,
//            y: circle.center.y - circle.radius,
//            width: circle.radius * 2,
//            height: circle.radius * 2
//        ))
//        context?.fillPath()
//
//        let percentageText = "\(Int((circle.radius - minRadius) / (maxRadius - minRadius) * 100))%"
//        let textAttributes: [NSAttributedString.Key: Any] = [
//            .font: UITheme.Font.SettingsScene.categoryPersent,
//            .foregroundColor: UITheme.Colors.appBlack,
//        ]
//        let textSize = percentageText.size(withAttributes: textAttributes)
//        let textRect = CGRect(
//            x: circle.center.x - textSize.width / 2,
//            y: circle.center.y - textSize.height / 2,
//            width: textSize.width,
//            height: textSize.height
//        )
//        percentageText.draw(in: textRect, withAttributes: textAttributes)
//    }
//
//    private func generatePositions(count: Int, width: CGFloat, height: CGFloat) -> [CGPoint] {
//        var positions: [CGPoint] = []
//        let centerX = width / 2
//        let centerY = height / 2
//        let radius = min(width, height) / 3
//
//        if count == 1 {
//            positions.append(CGPoint(x: centerX, y: centerY))
//        } else {
//            for index in 0 ..< count {
//                let angle = CGFloat(index) * (2 * .pi / CGFloat(count))
//                let posX = centerX + radius * cos(angle)
//                let posY = centerY + radius * sin(angle)
//                positions.append(CGPoint(x: posX, y: posY))
//            }
//        }
//
//        return positions
//    }
// }
import UIKit

final class GroupedEmotionsChartView: UIView {
    private struct Circle {
        let center: CGPoint
        let radius: CGFloat
        let color: UIColor
        let percentage: Int
    }

    private var circles: [Circle] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    func configure(with data: [EmotionCategory: Int]) {
        let filteredData = data.filter { $0.key.localizedName != EmotionType.placeholder.name }
        let total = CGFloat(filteredData.values.reduce(0, +))

        guard total > 0 else {
            circles = [Circle(
                center: CGPoint(x: bounds.midX, y: bounds.midY),
                radius: min(bounds.width, bounds.height) / 3,
                color: .gray,
                percentage: 0
            )]
            setNeedsDisplay()
            return
        }

        let normalizedData = filteredData.map { category, count in
            (category.color, Int((CGFloat(count) / total) * 100))
        }

        circles = calculateCircles(with: normalizedData)
        setNeedsDisplay()
    }

    override func draw(_: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(), !circles.isEmpty else { return }

        for circle in circles.reversed() {
            drawCircle(in: context, circle: circle)
        }
    }

    // MARK: - Calculation of circles

    private func calculateCircles(with data: [(UIColor, Int)]) -> [Circle] {
        let width = bounds.width
        let height = bounds.height
        let minDimension = min(width, height)

        let count = data.count
        let maxRadius = count == 1 ? minDimension / 2.1 : minDimension / CGFloat(count + 1)
        let minRadius = maxRadius * 0.6

        let sortedData = data.sorted { $0.1 > $1.1 }
        var positions: [CGPoint] = []

        var resultCircles: [Circle] = []
        for (_, (color, percentage)) in sortedData.enumerated() {
            let radius = minRadius + (maxRadius - minRadius) * CGFloat(percentage) / 100
            var circleCenter: CGPoint

            repeat {
                circleCenter = generateRandomPosition(width: width, height: height, radius: radius)
            } while isOverlapping(circleCenter, radius, positions)

            positions.append(circleCenter)
            resultCircles.append(Circle(center: circleCenter, radius: radius, color: color, percentage: percentage))
        }

        return resultCircles
    }

    // MARK: - Отрисовка

    private func drawCircle(in context: CGContext, circle: Circle) {
        context.setFillColor(circle.color.cgColor)
        context.addEllipse(in: CGRect(
            x: circle.center.x - circle.radius,
            y: circle.center.y - circle.radius,
            width: circle.radius * 2,
            height: circle.radius * 2
        ))
        context.fillPath()

        drawPercentageText(in: context, circle: circle)
    }

    private func drawPercentageText(in _: CGContext, circle: Circle) {
        let percentageText = "\(circle.percentage)%"
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UITheme.Font.SettingsScene.categoryPersent,
            .foregroundColor: UITheme.Colors.appBlack,
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

    // MARK: -Generation of random positions

    private func generateRandomPosition(width: CGFloat, height: CGFloat, radius: CGFloat) -> CGPoint {
        let safeX = radius + CGFloat.random(in: 0 ... (width - 2 * radius))
        let safeY = radius + CGFloat.random(in: 0 ... (height - 2 * radius))
        return CGPoint(x: safeX, y: safeY)
    }

    private func isOverlapping(_ point: CGPoint, _ radius: CGFloat, _ existingPoints: [CGPoint]) -> Bool {
        for existingPoint in existingPoints {
            let distance = sqrt(pow(existingPoint.x - point.x, 2) + pow(existingPoint.y - point.y, 2))
            if distance < radius * 1.5 {
                return true
            }
        }
        return false
    }
}
