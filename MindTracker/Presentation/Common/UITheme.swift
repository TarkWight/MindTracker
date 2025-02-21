//
//  UITheme.swift
//  MindTracker
//
//  Created by Tark Wight on 21.02.2025.
//

import UIKit

enum UITheme {
    private static func customFont(name: String, size: CGFloat) -> UIFont {
        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    enum Font {
        enum AuthScene {
            static let title = customFont(name: "Gwen-Trial", size: 48)
        }
    }
}
