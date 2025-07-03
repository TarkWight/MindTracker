//
//  EmotionOverviewView.swift
//  MindTracker
//
//  Created by Tark Wight on 03.03.2025.
//

import UIKit

final class EmotionOverviewView: UIView {
    // MARK: - Properties

    private var previousDataHash: Int?

    private var circles: [Circle] = []

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    // MARK: - Public Configuration

    func configure(with data: [EmotionCategory: Int]) {
        let filteredData = data.filter {
            $0.key.localizedName != EmotionType.placeholder.name
        }

        let newHash = hashOf(filteredData)
        guard newHash != previousDataHash else {
            return
        }
        previousDataHash = newHash

        let total = CGFloat(filteredData.values.reduce(0, +))

        guard total > 0 else {
            circles = [
                Circle(
                    center: CGPoint(x: bounds.midX, y: bounds.midY),
                    radius: min(bounds.width, bounds.height) / 3,
                    category: EmotionCategory.none,
                    percentage: 0
                )
            ]
            setNeedsDisplay()
            return
        }

        let rawNormalized: [(EmotionCategory, Double)] =
            filteredData.map {
                ($0.key, Double($0.value) / Double(total) * 100)
            }

        let rounded = rawNormalized.map { ($0.0, Int($0.1)) }
        let sum = rounded.reduce(0) { $0 + $1.1 }

        let remainders = rawNormalized.enumerated()
            .map { (index, pair) in (index, pair.1 - Double(Int(pair.1))) }
            .sorted { $0.1 > $1.1 }

        var final: [(EmotionCategory, Int)] = rounded
        for (index, _) in remainders.prefix(100 - sum) {
            final[index].1 += 1
        }

        circles = calculateCircles(with: final)
        setNeedsDisplay()
    }

    // MARK: - Layout / Drawing

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(), !circles.isEmpty
        else { return }

        for circle in circles {
            drawCircle(in: context, circle: circle)
        }
    }
}
// MARK: - Private methods
extension EmotionOverviewView {
    fileprivate func drawCircle(in context: CGContext, circle: Circle) {
        guard
            let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: circle.category.gradientColors as CFArray,
                locations: [0, 1]
            )
        else {
            return
        }

        let center = circle.center
        let radius = circle.radius

        context.saveGState()
        context.addEllipse(
            in: CGRect(
                x: center.x - radius,
                y: center.y - radius,
                width: radius * 2,
                height: radius * 2
            )
        )
        context.clip()

        context.drawLinearGradient(
            gradient,
            start: CGPoint(x: center.x, y: center.y - radius),
            end: CGPoint(x: center.x, y: center.y + radius),
            options: []
        )
        context.restoreGState()

        drawPercentageText(in: context, circle: circle)
    }

    fileprivate func drawPercentageText(in _: CGContext, circle: Circle) {
        let percentageText = "\(circle.percentage)%"
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: Typography.header4,
            .foregroundColor: AppColors.appBlack,
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

    // MARK: - Circle Calculation

    fileprivate func calculateCircles(with data: [(EmotionCategory, Int)])
        -> [Circle] {
        let width = bounds.width
        let height = bounds.height
        let maxRadius = min(width, height) / 2.1

        let positions = centerTemplate(for: data.count)
        let sortedData = Array(data.prefix(4)).sorted { $0.1 > $1.1 }

        var circles: [Circle] = []

        for (index, (category, percentage)) in sortedData.enumerated() {
            let basePoint = positions[index]
            let radius = maxRadius * sqrt(CGFloat(percentage) / 100)

            let context = CirclePlacementContext(
                templatePoint: basePoint,
                radius: radius,
                existingCircles: circles,
                canvasSize: CGSize(width: width, height: height)
            )

            let center = findValidCenter(using: context)

            let circle = Circle(
                center: center,
                radius: radius,
                category: category,
                percentage: percentage
            )
            circles.append(circle)
        }

        return circles
    }

    fileprivate func centerTemplate(for count: Int) -> [CGPoint] {
        let templates: [[CGPoint]] = [
            [],
            [CGPoint(x: 0.5, y: 0.5)],
            [CGPoint(x: 0.35, y: 0.35), CGPoint(x: 0.65, y: 0.65)],
            [
                CGPoint(x: 0.35, y: 0.35), CGPoint(x: 0.65, y: 0.65),
                CGPoint(x: 0.65, y: 0.35),
            ],
            [
                CGPoint(x: 0.35, y: 0.35), CGPoint(x: 0.65, y: 0.65),
                CGPoint(x: 0.65, y: 0.35), CGPoint(x: 0.35, y: 0.65),
            ],
        ]
        return templates[min(count, templates.count - 1)]
    }

    fileprivate func findValidCenter(using context: CirclePlacementContext)
        -> CGPoint {
        let width = context.canvasSize.width
        let height = context.canvasSize.height

        for _ in 0..<context.maxAttempts {
            let offsetX = CGFloat.random(in: -context.jitter...context.jitter)
            let offsetY = CGFloat.random(in: -context.jitter...context.jitter)

            let candidate = CGPoint(
                x: clamp(
                    context.templatePoint.x * width + offsetX,
                    min: context.radius,
                    max: width - context.radius
                ),
                y: clamp(
                    context.templatePoint.y * height + offsetY,
                    min: context.radius,
                    max: height - context.radius
                )
            )

            if isCenterValid(
                candidate,
                radius: context.radius,
                existing: context.existingCircles,
                multiplier: context.minDistanceMultiplier
            ) {
                return candidate
            }
        }

        return CGPoint(
            x: clamp(
                context.templatePoint.x * width,
                min: context.radius,
                max: width - context.radius
            ),
            y: clamp(
                context.templatePoint.y * height,
                min: context.radius,
                max: height - context.radius
            )
        )
    }

    fileprivate func isCenterValid(
        _ center: CGPoint,
        radius: CGFloat,
        existing: [Circle],
        multiplier: CGFloat
    ) -> Bool {
        for other in existing {
            let dist = hypot(
                other.center.x - center.x,
                other.center.y - center.y
            )
            if dist < (other.radius + radius) * multiplier {
                return false
            }
        }
        return true
    }

    fileprivate func clamp(_ value: CGFloat, min: CGFloat, max: CGFloat)
        -> CGFloat {
        return Swift.max(min, Swift.min(max, value))
    }

    // MARK: - Gradient

    fileprivate func gradientColors(from baseColor: UIColor) -> [CGColor] {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        baseColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let top = UIColor(
            red: red,
            green: green,
            blue: min(blue + 0.25, 1.0),
            alpha: alpha
        )

        let bottom = UIColor(
            red: max(red - 0.2, 0.0),
            green: green,
            blue: max(blue - 0.15, 0.0),
            alpha: alpha
        )

        return [top.cgColor, bottom.cgColor]
    }

    // MARK: - Hashing

    fileprivate func hashOf(_ data: [EmotionCategory: Int]) -> Int {
        var hasher = Hasher()
        for (key, value) in data.sorted(by: {
            $0.key.localizedName < $1.key.localizedName
        }) {
            hasher.combine(key.localizedName)
            hasher.combine(value)
        }
        return hasher.finalize()
    }
}

extension EmotionOverviewView {
    fileprivate struct Circle {
        let center: CGPoint
        let radius: CGFloat
        let category: EmotionCategory
        let percentage: Int

        var textRect: CGRect {
            let textSize = "\(percentage)%".size(withAttributes: [
                .font: Typography.header4
            ])
            let padding: CGFloat = 50

            return CGRect(
                x: center.x - textSize.width / 2 - padding,
                y: center.y - textSize.height / 2 - padding,
                width: textSize.width + padding * 2,
                height: textSize.height + padding * 2
            )
        }
    }

    fileprivate struct CirclePlacementContext {
        let templatePoint: CGPoint
        let radius: CGFloat
        let existingCircles: [Circle]
        let canvasSize: CGSize
        let jitter: CGFloat
        let maxAttempts: Int
        let minDistanceMultiplier: CGFloat

        init(
            templatePoint: CGPoint,
            radius: CGFloat,
            existingCircles: [Circle],
            canvasSize: CGSize,
            jitter: CGFloat = 15,
            maxAttempts: Int = 30,
            minDistanceMultiplier: CGFloat = 1.2
        ) {
            self.templatePoint = templatePoint
            self.radius = radius
            self.existingCircles = existingCircles
            self.canvasSize = canvasSize
            self.jitter = jitter
            self.maxAttempts = maxAttempts
            self.minDistanceMultiplier = minDistanceMultiplier
        }
    }
}
