//
//  MockFaceIDService.swift
//  MindTracker
//
//  Created by Tark Wight on 24.05.2025.
//

import Foundation

@testable import MindTracker

final actor MockFaceIDService: FaceIDServiceProtocol {
    var isEnabled = false
    var shouldThrow = false

    func isFaceIDEnabled() async throws -> Bool {
        if shouldThrow { throw NSError(domain: "FaceID", code: 1) }
        return isEnabled
    }

    func setFaceIDEnabled(_ isEnabled: Bool) async throws {
        if shouldThrow { throw NSError(domain: "FaceID", code: 2) }
        self.isEnabled = isEnabled
    }
}
