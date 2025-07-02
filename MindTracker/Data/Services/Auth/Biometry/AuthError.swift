//
//  AuthError.swift
//  MindTracker
//
//  Created by Tark Wight on 03.07.2025.
//

import Foundation

enum AuthError: Error, Equatable, LocalizedError {
    case biometryUnavailable
        case biometryFailed
        case biometryNotEnrolled
        case biometryLockout

    var errorDescription: String? {
        switch self {
        case .biometryUnavailable:
            return LocalizedKey.biometryUnavailable
        case .biometryFailed:
            return LocalizedKey.biometryFailed
        case .biometryNotEnrolled:
            return LocalizedKey.biometryNotEnrolled
        case .biometryLockout:
            return LocalizedKey.biometryLockout
        }
    }
}
