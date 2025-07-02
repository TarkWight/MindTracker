//
//  AppFactory.swift
//  MindTracker
//
//  Created by Tark Wight on 21.02.2025.
//

import CoreData
import Foundation

final class AppFactory {

    private let persistentContainer: NSPersistentContainer

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    lazy var keyChainService: KeychainServiceProtocol = {
        KeychainService()
    }()

    lazy var appleService: AppleSignInServiceProtocol = {
        AppleSignInService(keychainService: keyChainService)
    }()

    lazy var reminderSchedulerService: ReminderSchedulerServiceProtocol = {
        ReminderSchedulerService()
    }()

    lazy var emotionMapper: EmotionMapperProtocol = {
        EmotionMapper()
    }()

    lazy var reminderMapper: ReminderMapperProtocol = {
        ReminderMapper()
    }()

    lazy var tagMapper: TagMapperProtocol = {
        TagMapper()
    }()

    lazy var emotionStorageService: EmotionServiceProtocol = {
        EmotionService(
            context: persistentContainer.viewContext,
            mapper: emotionMapper
        )
    }()

    lazy var tagStorageService: TagServiceProtocol = {
        let defaultTags: [TagType: [String]] = [
            .activity: [
                LocalizedKey.tagEating,
                LocalizedKey.tagMeetingFriends,
                LocalizedKey.tagSport,
                LocalizedKey.tagHobby,
                LocalizedKey.tagRest,
                LocalizedKey.tagTravel,
            ],
            .people: [
                LocalizedKey.tagAlone,
                LocalizedKey.tagFriends,
                LocalizedKey.tagFamily,
                LocalizedKey.tagCoworkers,
                LocalizedKey.tagPartner,
                LocalizedKey.tagPets,
            ],
            .location: [
                LocalizedKey.tagHome,
                LocalizedKey.tagWork,
                LocalizedKey.tagSchool,
                LocalizedKey.tagTransport,
                LocalizedKey.tagOutside,
            ],
        ]
        return TagService(
            context: persistentContainer.viewContext,
            defaultTags: defaultTags,
            mapper: tagMapper
        )
    }()

    lazy var authService: AuthServiceProtocol = {
        AuthService(
            biometry: biometryService,
            apple: appleService)
    }()

    lazy var biometryService: BiometryServiceProtocol = {
        BiometryService(keychain: keyChainService)
    }()

    lazy var reminderService: ReminderServiceProtocol = {
        ReminderService(
            context: persistentContainer.viewContext,
            mapper: reminderMapper,
            reminderSchedulerService: reminderSchedulerService
        )
    }()

    lazy var avatarService = AvatarService()
}
