//
//  Collection+Safe.swift
//  MindTracker
//
//  Created by Tark Wight on 02.03.2025.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
