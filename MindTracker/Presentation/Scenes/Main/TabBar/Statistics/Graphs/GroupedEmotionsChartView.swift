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
        let total = CGFloat(data.values.reduce(0, +))
        emotionGroups = data.map { ($0.key.color, CGFloat($0.value) / total) }
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

        let positions: [CGPoint] = [
            CGPoint(x: width * 0.3, y: height * 0.3),
            CGPoint(x: width * 0.3, y: height * 0.7),
            CGPoint(x: width * 0.7, y: height * 0.2),
            CGPoint(x: width * 0.7, y: height * 0.7)
        ]

        for (index, (color, percentage)) in sortedGroups.enumerated() {
            let radius = minRadius + (maxRadius - minRadius) * percentage
            let circleCenter = positions[index]

            circles.append((circleCenter, radius, color))
        }

        let context = UIGraphicsGetCurrentContext()

        if circles.count == 1 {
            drawCircle(context: context, circle: circles[0], minRadius: minRadius, maxRadius: maxRadius)
        } else if circles.count == 2 {
            drawCircle(context: context, circle: circles[1], minRadius: minRadius, maxRadius: maxRadius)
            drawCircle(context: context, circle: circles[0], minRadius: minRadius, maxRadius: maxRadius)
        } else if circles.count == 3 {
            drawCircle(context: context, circle: circles[2], minRadius: minRadius, maxRadius: maxRadius)
            drawCircle(context: context, circle: circles[0], minRadius: minRadius, maxRadius: maxRadius)
            drawCircle(context: context, circle: circles[1], minRadius: minRadius, maxRadius: maxRadius)
        } else if circles.count == 4 {
            drawCircle(context: context, circle: circles[3], minRadius: minRadius, maxRadius: maxRadius)
            drawCircle(context: context, circle: circles[2], minRadius: minRadius, maxRadius: maxRadius)
            drawCircle(context: context, circle: circles[0], minRadius: minRadius, maxRadius: maxRadius)
            drawCircle(context: context, circle: circles[1], minRadius: minRadius, maxRadius: maxRadius)
        }
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
}

private extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return hypot(x - point.x, y - point.y)
    }
}
