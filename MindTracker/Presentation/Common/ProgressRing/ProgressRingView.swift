//
//  ProgressRingView.swift
//  MindTracker
//
//  Created by Tark Wight on 02.03.2025.
//

import UIKit

final class ProgressRingView: UIView {
    private let backgroundLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let animationLayer = CAShapeLayer()
    private var animationTimer: Timer?
    var currentColors: [UIColor] = []

    var progress: CGFloat = 0 {
        didSet {
            updateProgress()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(progressLayer)
        layer.addSublayer(animationLayer)

        backgroundLayer.strokeColor = UITheme.Colors.appGrayDark.cgColor
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineWidth = 27

        progressLayer.strokeColor = UIColor.clear.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 27
        progressLayer.lineCap = .round

        animationLayer.strokeColor = UITheme.Colors.appGrayLight.cgColor
        animationLayer.fillColor = UIColor.clear.cgColor
        animationLayer.lineWidth = 27
        animationLayer.lineCap = .round
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = bounds.width / 2 - 27 / 2

        let path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -.pi / 2,
            endAngle: .pi * 1.5,
            clockwise: true
        )

        backgroundLayer.path = path.cgPath
        progressLayer.path = path.cgPath

        let chordPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -.pi / 2,
            endAngle: -.pi / 2 - (.pi * 4 / 5),
            clockwise: false
        )
        animationLayer.path = chordPath.cgPath
    }

    func startAnimation() {
        guard animationTimer == nil else { return }

        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = 2 * CGFloat.pi
        rotation.duration = 10
        rotation.repeatCount = .infinity
        rotation.isRemovedOnCompletion = false
        rotation.fillMode = .forwards

        layer.add(rotation, forKey: "rotationAnimation")

        let fade = CAKeyframeAnimation(keyPath: "opacity")
        fade.values = [1]
        fade.keyTimes = [1]
        fade.duration = .infinity
        fade.repeatCount = .infinity
        fade.isRemovedOnCompletion = false

        animationLayer.add(fade, forKey: "fadeAnimation")

        animationTimer = Timer.scheduledTimer(
            timeInterval: 0.03,
            target: self,
            selector: #selector(rotateLayer),
            userInfo: nil,
            repeats: true
        )
    }

    @objc private func rotateLayer() {
        transform = transform.rotated(by: -0.02)
    }

    func stopAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
        layer.removeAnimation(forKey: "rotationAnimation")
        animationLayer.removeAnimation(forKey: "fadeAnimation")
    }

    private func updateProgress() {
        let strokeEnd = min(progress / 1.0, 1.0)
        progressLayer.strokeEnd = strokeEnd
    }

    func setEmotionColors(_ colors: [UIColor]) {
        stopAnimation()
        currentColors = colors
        applyGradient()
    }

    private func applyGradient() {
        guard !currentColors.isEmpty else { return }

        stopAnimation()

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds

        if currentColors.count == 1 {
            let firstColor = currentColors[0].cgColor
            let secondColor = UITheme.Colors.appGrayDark.cgColor

            gradientLayer.colors = [firstColor, firstColor, secondColor, secondColor]
            gradientLayer.locations = [0, 0.5, 0.5, 1]
        } else {
            let firstColor = currentColors[0].cgColor
            let secondColor = currentColors[1].cgColor

            gradientLayer.colors = [firstColor, firstColor, secondColor, secondColor]
            gradientLayer.locations = [0, 0.5, 0.5, 1]
        }

        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)

        let maskLayer = CAShapeLayer()
        maskLayer.path = progressLayer.path
        maskLayer.lineWidth = progressLayer.lineWidth
        maskLayer.strokeColor = UIColor.black.cgColor
        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.lineCap = .round
        maskLayer.strokeStart = 0
        maskLayer.strokeEnd = 1

        gradientLayer.mask = maskLayer

        layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        layer.addSublayer(gradientLayer)
    }

    func forceRedraw() {
        setNeedsLayout()
        layoutIfNeeded()
        applyGradient()
    }
}
