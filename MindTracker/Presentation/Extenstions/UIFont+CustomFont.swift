//
//  UIFont+CustomFont.swift
//  MindTracker
//
//  Created by Tark Wight on 21.04.2025.
//

import UIKit

extension UIFont {
    static func custom(_ name: String, size: CGFloat, weight: UIFont.Weight) -> UIFont {
        UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
    }
}
