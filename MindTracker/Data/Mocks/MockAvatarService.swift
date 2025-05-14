//
//  MockAvatarService.swift
//  MindTracker
//
//  Created by Tark Wight on 06.05.2025.
//

import Foundation

actor MockAvatarService: AvatarServiceProtocol {

    private var storedAvatarData: Data?

       func loadAvatar() async throws -> Data? {
           guard let storedAvatarData else {
               throw AvatarServiceError.avatarNotFound
           }
           return storedAvatarData
       }

       func saveAvatar(_ avatar: Avatar) async throws {
           guard storedAvatarData == nil else {
               throw AvatarServiceError.avatarAlreadyExists
           }

           storedAvatarData = avatar.data
       }

       func updateAvatar(_ avatar: Avatar) async throws {
           guard storedAvatarData != nil else {
               throw AvatarServiceError.noAvatarToUpdate
           }

           storedAvatarData = avatar.data
       }

       func deleteAvatar() async throws {
           guard storedAvatarData != nil else {
               throw AvatarServiceError.noAvatarToDelete
           }

           storedAvatarData = nil
       }
}
