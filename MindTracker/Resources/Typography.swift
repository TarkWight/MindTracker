//
//  Typography.swift
//  MindTracker
//
//  Created by Tark Wight on 21.04.2025.
//

import UIKit

enum Typography {

    // MARK: - Title
    static let title = customFont(name: "Gwen-Trial", size: 48)

    static let header1 = customFont(name: "Gwen-Trial", size: 36)
    static let header2 = customFont(name: "Gwen-Trial", size: 28)
    static let header3 = customFont(name: "VelaSans-GX", size: 24)
    static let header3alt = customFont(name: "Gwen-Trial", size: 24)
    static let header4 = customFont(name: "VelaSans-GX", size: 20)

    static let body = customFont(name: "VelaSans-GX", size: 16)
    static let bodySmall = customFont(name: "VelaSans-GX", size: 14)
    static let bodySmallAlt = customFont(name: "VelaSans-GX", size: 12)

    static let displayMedium = customFont(name: "VelaSans-GX", size: 45)

    static let caption = customFont(name: "GwenText-Trial-Bold", size: 10)

    private static func customFont(name: String, size: CGFloat) -> UIFont {
        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
