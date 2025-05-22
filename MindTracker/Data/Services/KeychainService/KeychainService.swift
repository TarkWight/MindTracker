//
//  KeychainService.swift
//  MindTracker
//
//  Created by Tark Wight on 22.05.2025.
//

import Foundation
import Security

final class KeychainService: KeychainServiceProtocol {
    func save(_ value: Bool, for key: String) {
        let data = Data([value ? 1 : 0])
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    func loadBool(for key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        if SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess,
           let data = result as? Data,
           let byte = data.first {
            return byte == 1
        }
        return false
    }
}

