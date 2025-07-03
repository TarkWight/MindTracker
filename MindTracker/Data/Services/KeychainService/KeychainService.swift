//
//  KeychainService.swift
//  MindTracker
//
//  Created by Tark Wight on 22.05.2025.
//

import Foundation
import Security

final class KeychainService: KeychainServiceProtocol {
    func save(_ value: Bool, for key: String) async throws {
        let data = Data([value ? 1 : 0])
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
        ]
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            throw NSError(domain: "Keychain", code: Int(status), userInfo: nil)
        }
    }

    func save(_ value: Double, for key: String) async throws {
        var double = value
        let data = Data(bytes: &double, count: MemoryLayout<Double>.size)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
        ]
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            throw NSError(domain: "Keychain", code: Int(status), userInfo: nil)
        }
    }

    func loadBool(for key: String) async throws -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        if status == errSecSuccess,
            let data = result as? Data,
            let byte = data.first {
            return byte == 1
        } else if status == errSecItemNotFound {
            return false
        } else {
            throw NSError(domain: "Keychain", code: Int(status), userInfo: nil)
        }
    }

    func loadDouble(for key: String) async throws -> Double {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        if status == errSecSuccess,
            let data = result as? Data,
            data.count == MemoryLayout<Double>.size {
            return data.withUnsafeBytes { $0.load(as: Double.self) }
        } else if status == errSecItemNotFound {
            return 0
        } else {
            throw NSError(domain: "Keychain", code: Int(status), userInfo: nil)
        }
    }
}
