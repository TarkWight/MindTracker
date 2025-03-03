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
    private var animationTimer: Timer?
    private var currentColors: [UIColor] = []
    
    var progress: CGFloat = 0 {
        didSet {
            updateProgress()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(progressLayer)
        
        backgroundLayer.strokeColor = UITheme.Colors.appGray.cgColor // Серый фон
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineWidth = 27
        
        progressLayer.strokeColor = UIColor.clear.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 27
        progressLayer.lineCap = .round
        
        startAnimation()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let path = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                                radius: bounds.width / 2 - 27 / 2,
                                startAngle: -.pi / 2,
                                endAngle: .pi * 1.5,
                                clockwise: true)
        
        backgroundLayer.path = path.cgPath
        progressLayer.path = path.cgPath
    }
    
    func startAnimation() {
        guard animationTimer == nil else { return }
        animationTimer = Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(rotateLayer), userInfo: nil, repeats: true)
    }
    
    @objc private func rotateLayer() {
        transform = transform.rotated(by: 0.02)
    }
    
    func stopAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
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
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = currentColors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = progressLayer.path
        maskLayer.lineWidth = progressLayer.lineWidth
        maskLayer.strokeColor = UIColor.black.cgColor
        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.lineCap = .round
        maskLayer.strokeStart = 0
        maskLayer.strokeEnd = 1
        
        gradientLayer.mask = maskLayer
        layer.addSublayer(gradientLayer)
    }
}
