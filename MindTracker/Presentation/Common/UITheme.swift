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
            static let googleButton = customFont(name: "VelaSans-GX", size: 16)
        }
    }
    
    enum Icons {
        enum AuthScene {
            static let google = UIImage(named: "GoogleIcon")
        }
    }
    
    enum Colors {
        static let appWhite: UIColor = .appWhite
        static let appBlack: UIColor = .appBlack
    }
}
