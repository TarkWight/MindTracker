//
//  JournalStatsViewConfiguration.swift
//  MindTracker
//
//  Created by Tark Wight on 26.04.2025.
//

import UIKit

struct JournalStatsViewConfiguration {
    let backgroundColor: UIColor
    let textColor: UIColor
    let prefixFont: UIFont?
    let valueFont: UIFont
    let cornerRadius: CGFloat
    let contentInsets: UIEdgeInsets
    let height: CGFloat

    static let `default` = JournalStatsViewConfiguration(
        backgroundColor: AppColors.appGray,
        textColor: AppColors.appWhite,
        prefixFont: Typography.bodySmallAlt,
        valueFont: Typography.bodySmallAltBold,
        cornerRadius: 16,
        contentInsets: UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12),
        height: 32
    )
}
