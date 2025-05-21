//
//  FaceIDServiceProtocol.swift
//  MindTracker
//
//  Created by Tark Wight on 06.05.2025.
//

import Foundation
import AuthenticationServices

protocol FaceIDServiceProtocol: Sendable {
    func isFaceIDEnabled() async throws -> Bool
    func setFaceIDEnabled(_ isEnabled: Bool) async throws
}

protocol AppleSignInServiceProtocol: Sendable {
    func signIn() async throws -> AppleSignInCredential
}

struct AppleSignInCredential {
    let user: String
    let fullName: PersonNameComponents?
    let email: String?
    let isLikelyReal: Bool
}
