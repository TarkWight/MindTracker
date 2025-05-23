//
//  GradientView.swift
//  MindTracker
//
//  Created by Tark Wight on 24.05.2025.
//

import UIKit

class GradientView: UIView {
    var layoutSubviewsCallback: (() -> Void)?

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutSubviewsCallback?()
    }
}
