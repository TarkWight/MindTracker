//
//  Typography.swift
//  MindTracker
//
//  Created by Tark Wight on 21.04.2025.
//

import UIKit

enum Typography {

    // MARK: - Titles (Gwen-Trial)

    static let title = Gwen.custom(size: 48)
    static let header1 = Gwen.custom(size: 36)
    static let header2 = Gwen.custom(size: 28)
    static let header3alt = Gwen.custom(size: 24)

    // MARK: - Texts (VelaSans-GX)

    static let header3 = VelaSans.custom(size: 24, weight: .regular)
    static let header4 = VelaSans.custom(size: 20, weight: .regular)

    static let body = VelaSans.custom(size: 16, weight: .regular)
    static let bodySmall = VelaSans.custom(size: 14, weight: .regular)
    static let bodySmallAlt = VelaSans.custom(size: 12, weight: .regular)
    static let bodySmallAltBold = VelaSans.custom(size: 12, weight: .bold)

    static let displayMedium = VelaSans.custom(size: 45, weight: .bold)
    static let displayMedium1 = VelaSans.custom(size: 57, weight: .regular)

    // MARK: - Captions

    static let caption = GwenText.custom(size: 10)
    static let selectedCell =  GwenText.custom(size: 16)

    // MARK: - Private font loading

    private enum Gwen {
        static func custom(size: CGFloat) -> UIFont {
            UIFont(name: "Gwen-Trial", size: size) ?? UIFont.systemFont(ofSize: size)
        }
    }

    private enum GwenText {
        static func custom(size: CGFloat) -> UIFont {
            UIFont(name: "GwenText-Trial-Bold", size: size) ?? UIFont.systemFont(ofSize: size)
        }
    }

    private enum VelaSans {
        static func custom(size: CGFloat, weight: UIFont.Weight) -> UIFont {
            guard let font = UIFont(name: "VelaSans-GX", size: size) else {
                return UIFont.systemFont(ofSize: size, weight: weight)
            }
            let descriptor = font.fontDescriptor.addingAttributes([
                .traits: [UIFontDescriptor.TraitKey.weight: weight]
            ])
            return UIFont(descriptor: descriptor, size: size)
        }
    }
}
