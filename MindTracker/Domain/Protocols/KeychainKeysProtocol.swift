//
//  KeychainKeysProtocol.swift
//  MindTracker
//
//  Created by Tark Wight on 22.05.2025.
//

import Foundation

protocol KeychainServiceProtocol: Sendable {
    func save(_ value: Bool, for key: String)
    func loadBool(for key: String) -> Bool
}
