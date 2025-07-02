//
//  AuthError.swift
//  MindTracker
//
//  Created by Tark Wight on 03.07.2025.
//

import Foundation

enum AuthError: LocalizedError {
    case biometryUnavailable
    case biometryFailed

    var errorDescription: String? {
        switch self {
        case .biometryUnavailable:
            return LocalizedKey.biometryUnavailable
        case .biometryFailed:
            return LocalizedKey.biometryFailed
        }
    }
}
