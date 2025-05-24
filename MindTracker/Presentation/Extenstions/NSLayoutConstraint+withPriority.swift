//
//  NSLayoutConstraint+withPriority.swift
//  MindTracker
//
//  Created by Tark Wight on 10.05.2025.
//

import UIKit

extension NSLayoutConstraint {
    @discardableResult
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
