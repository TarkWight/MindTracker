//
//  AvatarService.swift
//  MindTracker
//
//  Created by Tark Wight on 06.05.2025.
//

import Foundation

actor AvatarService: AvatarServiceProtocol {
    private let fileName = "avatar"
    private var inMemoryAvatar: Avatar?

    private var fileURL: URL {
        FileManager.default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
    }

    func loadAvatar() async throws -> Data? {
        if let cached = inMemoryAvatar?.data {
            return cached
        }
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }
        let data = try Data(contentsOf: fileURL)
        inMemoryAvatar = Avatar(data: data)
        return data
    }

    func saveAvatar(_ avatar: Avatar) async throws {
        try writeToDisk(avatar)
        inMemoryAvatar = avatar
    }

    func updateAvatar(_ avatar: Avatar) async throws {
        try await deleteAvatar()
        try await saveAvatar(avatar)
    }

    func deleteAvatar() async throws {
        inMemoryAvatar = nil
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try FileManager.default.removeItem(at: fileURL)
        }
    }

    private func writeToDisk(_ avatar: Avatar) throws {
        guard let data = avatar.data else {
            throw AvatarServiceError.invalidData
        }
        try FileManager.default.createDirectory(
            at: fileURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try data.write(to: fileURL, options: .atomic)
    }

    enum AvatarServiceError: Error {
        case invalidData
    }
}
