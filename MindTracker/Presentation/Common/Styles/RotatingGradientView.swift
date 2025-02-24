//
//  RotatingGradientView.swift
//  MindTracker
//
//  Created by Tark Wight on 21.02.2025.
//

import UIKit

class RotatingGradientView: UIView {
    
    private let containerLayer = CALayer()
    private let gradientLayers: [CAGradientLayer] = (0..<4).map { _ in CAGradientLayer() }
    
    private let colors: [UIColor] = [
        .skyBlue,
        .limeGreen,
        .sunsetOrange,
        .cherryRed
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContainerLayer()
        backgroundColor = .white.withAlphaComponent(0.8)
        startRotationAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContainerLayer() {
        gradientLayers.forEach { containerLayer.addSublayer($0) }
        layer.addSublayer(containerLayer)
    }
    
    private func updateGradientLayers() {
        let squareSize = max(bounds.width, bounds.height) * 1.84
        let gradientRadius = squareSize * 0.5
        let offset: CGFloat = 0.5
        
        containerLayer.frame = bounds
        
        for (index, gradientLayer) in gradientLayers.enumerated() {
            let baseColor = colors[index]
            gradientLayer.colors = [
                baseColor.withAlphaComponent(0.5).cgColor,
                baseColor.withAlphaComponent(0.3).cgColor,
                UIColor.clear.cgColor
            ]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.5 + offset, y: 0.5 + offset)
            gradientLayer.type = .radial
            
            
            gradientLayer.frame = CGRect(x: 0, y: 0, width: squareSize, height: squareSize + offset)
            gradientLayer.cornerRadius = gradientRadius + offset
            
            gradientLayer.compositingFilter = "screenBlendMode"

            let position: CGPoint
            switch index {
            case 0:
                position = CGPoint(x: bounds.maxX, y: bounds.minY)
            case 1:
                position = CGPoint(x: bounds.minX, y: bounds.minY)
            case 2:
                position = CGPoint(x: bounds.minX, y: bounds.maxY)
            case 3:
                position = CGPoint(x: bounds.maxX, y: bounds.maxY)
            default:
                position = .zero
            }
            gradientLayer.position = position
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientLayers()
    }
    
    private func startRotationAnimation() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = CGFloat.pi * 2
        rotation.duration = 30.0
        rotation.repeatCount = .infinity
        rotation.timingFunction = CAMediaTimingFunction(name: .linear)
        containerLayer.add(rotation, forKey: "rotation")
    }
}
