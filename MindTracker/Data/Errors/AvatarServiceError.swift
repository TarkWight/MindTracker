//
//  AvatarServiceError.swift
//  MindTracker
//
//  Created by Tark Wight on 06.05.2025.
//

import Foundation

enum AvatarServiceError: Error, Sendable {
    case avatarNotFound
    case avatarAlreadyExists
    case noAvatarToUpdate
    case noAvatarToDelete
}
