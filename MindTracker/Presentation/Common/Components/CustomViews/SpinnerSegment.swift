//
//  SpinnerSegment.swift
//  MindTracker
//
//  Created by Tark Wight on 01.05.2025.
//

import UIKit

struct SpinnerSegment {
    let color: UIColor
    let strokeStart: CGFloat
    let strokeEnd: CGFloat
}

struct SpinnerData {
    let isLoading: Bool
    let segments: [SpinnerSegment]
    let gradientColors: [UIColor]
    let gradientLocations: [CGFloat]
    let animationDuration: CFTimeInterval
    let lineWidth: CGFloat
    let startAngle: CGFloat
    let endAngle: CGFloat
    let spinnerFraction: CGFloat
}
