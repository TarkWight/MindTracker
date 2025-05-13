//
//  Avatar.swift
//  MindTracker
//
//  Created by Tark Wight on 06.05.2025.
//

import Foundation
import UIKit

struct Avatar: Sendable {
    let data: Data?

    var image: UIImage? {
        guard let data else { return nil }
        return UIImage(data: data)
    }
}
