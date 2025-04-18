//
//  ButtonConfiguration.swift
//  MindTracker
//
//  Created by Tark Wight on 21.02.2025.
//

import UIKit

struct ButtonConfiguration {
    let title: String
    let textColor: UIColor
    let font: UIFont
    let fontSize: CGFloat
    let icon: UIImage?
    let iconSize: CGFloat
    let backgroundColor: UIColor
    let buttonHeight: CGFloat
    let cornerRadius: CGFloat
    let padding: CGFloat
    let iconPosition: CustomButton.IconPosition

    static let `default` = ButtonConfiguration(
        title: "",
        textColor: .black,
        font: .systemFont(ofSize: 16, weight: .medium),
        fontSize: 16,
        icon: nil,
        iconSize: 48,
        backgroundColor: .white,
        buttonHeight: 50,
        cornerRadius: 20,
        padding: 16,
        iconPosition: .left
    )
}
