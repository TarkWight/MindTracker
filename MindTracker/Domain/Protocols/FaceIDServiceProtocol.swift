//
//  FaceIDServiceProtocol.swift
//  MindTracker
//
//  Created by Tark Wight on 06.05.2025.
//

import Foundation

protocol FaceIDServiceProtocol: Sendable {
    func isFaceIDEnabled() async throws -> Bool
    func setFaceIDEnabled(_ isEnabled: Bool) async throws
}
