//
//  AppFactory.swift
//  MindTracker
//
//  Created by Tark Wight on 21.02.2025.
//

import Foundation
import CoreData

final class AppFactory {

    private let persistentContainer: NSPersistentContainer

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    lazy var keyChainService: KeychainServiceProtocol = {
        KeychainService()
    }()

    lazy var emotionStorageService: EmotionStorageServiceProtocol = {
        EmotionStorageService(
            context: persistentContainer.viewContext,
            mapper: EmotionMapper()
        )
    }()

    lazy var tagStorageService: TagStorageServiceProtocol = {
        let defaultTags: [TagType: [String]] = [
            .activity: [
                LocalizedKey.tagEating,
                LocalizedKey.tagMeetingFriends,
                LocalizedKey.tagSport,
                LocalizedKey.tagHobby,
                LocalizedKey.tagRest,
                LocalizedKey.tagTravel
            ],
            .people: [
                LocalizedKey.tagAlone,
                LocalizedKey.tagFriends,
                LocalizedKey.tagFamily,
                LocalizedKey.tagCoworkers,
                LocalizedKey.tagPartner,
                LocalizedKey.tagPets
            ],
            .location: [
                LocalizedKey.tagHome,
                LocalizedKey.tagWork,
                LocalizedKey.tagSchool,
                LocalizedKey.tagTransport,
                LocalizedKey.tagOutside
            ]
        ]
        return TagStorageService(context: persistentContainer.viewContext, defaultTags: defaultTags)
    }()

    lazy var appleSignInService: AppleSignInServiceProtocol = {
        AppleSignInService(keychainService: keyChainService)
    }()

    lazy var faceIDService: FaceIDServiceProtocol = {
        FaceIDService(keychainService: keyChainService)
    }()

    lazy var reminderService = MockReminderService()
    lazy var avatarService = AvatarService()
}
