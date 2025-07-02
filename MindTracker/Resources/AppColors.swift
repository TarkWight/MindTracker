//
//  AppColors.swift
//  MindTracker
//
//  Created by Tark Wight on 21.04.2025.
//

import UIKit

enum AppColors {
    static let background: UIColor = .appBlack

    static let appWhite: UIColor = .appWhite
    static let appBlack: UIColor = .appBlack
    static let appGray: UIColor = .appGray
    static let appGrayLight: UIColor = .appGrayLight
    static let appGrayLighter: UIColor = .appGrayLighter
    static let appGrayFaded: UIColor = .appGrayFaded
    static let appGrayDark: UIColor = .appGrayDark
    static let appGreen: UIColor = .appGreen

    static let emotionCardRed: UIColor = .emotionCardRed
    static let emotionCardGreen: UIColor = .emotionCardGreen
    static let emotionCardBlue: UIColor = .emotionCardBlue
    static let emotionCardYellow: UIColor = .emotionCardYellow

    enum Red {
        static let gradientStart = UIColor(
            red: 255 / 255,
            green: 85 / 255,
            blue: 51 / 255,
            alpha: 1.0
        )
        static let gradientEnd = UIColor(
            red: 255 / 255,
            green: 0 / 255,
            blue: 0 / 255,
            alpha: 1.0
        )
    }

    enum Blue {
        static let gradientStart = UIColor(
            red: 51 / 255,
            green: 221 / 255,
            blue: 255 / 255,
            alpha: 1.0
        )
        static let gradientEnd = UIColor(
            red: 0 / 255,
            green: 170 / 255,
            blue: 255 / 255,
            alpha: 1.0
        )
    }

    enum Green {
        static let gradientStart = UIColor(
            red: 51 / 255,
            green: 255 / 255,
            blue: 187 / 255,
            alpha: 1.0
        )
        static let gradientEnd = UIColor(
            red: 0 / 255,
            green: 255 / 255,
            blue: 85 / 255,
            alpha: 1.0
        )
    }

    enum Yellow {
        static let gradientStart = UIColor(
            red: 255 / 255,
            green: 255 / 255,
            blue: 51 / 255,
            alpha: 1.0
        )
        static let gradientEnd = UIColor(
            red: 255 / 255,
            green: 170 / 255,
            blue: 0 / 255,
            alpha: 1.0
        )
    }
}
