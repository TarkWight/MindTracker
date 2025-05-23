//
//  AppleSignInCredential.swift
//  MindTracker
//
//  Created by Tark Wight on 22.05.2025.
//

import Foundation

struct AppleSignInCredential {
    let user: String
    let fullName: PersonNameComponents?
    let email: String?
    let isLikelyReal: Bool
}
