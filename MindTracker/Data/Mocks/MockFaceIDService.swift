//
//  MockFaceIDService.swift
//  MindTracker
//
//  Created by Tark Wight on 06.05.2025.
//

import Foundation

actor MockFaceIDService: FaceIDServiceProtocol {
    private var isEnabled: Bool = false

    func isFaceIDEnabled() async throws -> Bool {
        return isEnabled
    }

    func setFaceIDEnabled(_ isEnabled: Bool) async throws {
        self.isEnabled = isEnabled
    }
}
