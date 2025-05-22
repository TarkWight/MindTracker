//
//  FaceIDService.swift
//  MindTracker
//
//  Created by Tark Wight on 06.05.2025.
//

import Foundation
import Security

actor FaceIDService: FaceIDServiceProtocol {
    private let keychainService: KeychainServiceProtocol
    private var isEnabledCache: Bool?

    init(keychainService: KeychainServiceProtocol) {
        self.keychainService = keychainService
    }

    func isFaceIDEnabled() async throws -> Bool {
        if let cached = isEnabledCache {
            return cached
        } else {
            let loaded = try await keychainService.loadBool(for: KeychainKeys.faceIDEnabled)
            isEnabledCache = loaded
            return loaded
        }
    }

    func setFaceIDEnabled(_ enabled: Bool) async throws {
        isEnabledCache = enabled
        try await keychainService.save(enabled, for: KeychainKeys.faceIDEnabled)
    }
}
