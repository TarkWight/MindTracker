//
//  MockTagsData.swift
//  MindTracker
//
//  Created by Tark Wight on 02.03.2025.
//

import Foundation

struct MockTagsData {
    static let activityTags: [String] = [
        LocalizedKey.Tags.activity.eating,
        LocalizedKey.Tags.activity.meetingFriends,
        LocalizedKey.Tags.activity.sport,
        LocalizedKey.Tags.activity.hobby,
        LocalizedKey.Tags.activity.rest,
        LocalizedKey.Tags.activity.travel
    ]
    
    static let peopleTags: [String] = [
        LocalizedKey.Tags.people.alone,
        LocalizedKey.Tags.people.friends,
        LocalizedKey.Tags.people.family,
        LocalizedKey.Tags.people.coworkers,
        LocalizedKey.Tags.people.partner,
        LocalizedKey.Tags.people.pets
    ]
    
    static let locationTags: [String] = [
        LocalizedKey.Tags.location.home,
        LocalizedKey.Tags.location.work,
        LocalizedKey.Tags.location.school,
        LocalizedKey.Tags.location.transport,
        LocalizedKey.Tags.location.outside
    ]
}
