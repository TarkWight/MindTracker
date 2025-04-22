//
//  MockTagsData.swift
//  MindTracker
//
//  Created by Tark Wight on 02.03.2025.
//

import Foundation

enum MockTagsData {
    static let activityTags: [String] = [
        LocalizedKey.tagEating,
        LocalizedKey.tagMeetingFriends,
        LocalizedKey.tagSport,
        LocalizedKey.tagHobby,
        LocalizedKey.tagRest,
        LocalizedKey.tagTravel,
    ]

    static let peopleTags: [String] = [
        LocalizedKey.tagAlone,
        LocalizedKey.tagFriends,
        LocalizedKey.tagFamily,
        LocalizedKey.tagCoworkers,
        LocalizedKey.tagPartner,
        LocalizedKey.tagPets,
    ]

    static let locationTags: [String] = [
        LocalizedKey.tagHome,
        LocalizedKey.tagWork,
        LocalizedKey.tagSchool,
        LocalizedKey.tagTransport,
        LocalizedKey.tagOutside,
    ]
}
