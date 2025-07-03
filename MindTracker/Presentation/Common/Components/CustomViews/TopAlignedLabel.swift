//
//  TopAlignedLabel.swift
//  MindTracker
//
//  Created by Tark Wight on 03.07.2025.
//

import UIKit

final class TopAlignedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let size = sizeThatFits(rect.size)
        let newRect = CGRect(
            x: rect.origin.x,
            y: rect.origin.y,
            width: rect.size.width,
            height: size.height
        )
        super.drawText(in: newRect)
    }
}
