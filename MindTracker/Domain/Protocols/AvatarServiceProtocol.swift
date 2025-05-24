//
//  AvatarServiceProtocol.swift
//  MindTracker
//
//  Created by Tark Wight on 06.05.2025.
//

import Foundation

protocol AvatarServiceProtocol: Sendable {
    func loadAvatar() async throws -> Data?
    func saveAvatar(_ avatar: Avatar) async throws
    func updateAvatar(_ avatar: Avatar) async throws
    func deleteAvatar() async throws
}
