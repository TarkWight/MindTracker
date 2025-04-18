//
//  MockTagsData.swift
//  MindTracker
//
//  Created by Tark Wight on 02.03.2025.
//

import Foundation

enum MockTagsData {
    static let activityTags: [String] = [
        LocalizedKey.Tags.Activity.eating,
        LocalizedKey.Tags.Activity.meetingFriends,
        LocalizedKey.Tags.Activity.sport,
        LocalizedKey.Tags.Activity.hobby,
        LocalizedKey.Tags.Activity.rest,
        LocalizedKey.Tags.Activity.travel,
    ]

    static let peopleTags: [String] = [
        LocalizedKey.Tags.People.alone,
        LocalizedKey.Tags.People.friends,
        LocalizedKey.Tags.People.family,
        LocalizedKey.Tags.People.coworkers,
        LocalizedKey.Tags.People.partner,
        LocalizedKey.Tags.People.pets,
    ]

    static let locationTags: [String] = [
        LocalizedKey.Tags.Location.home,
        LocalizedKey.Tags.Location.work,
        LocalizedKey.Tags.Location.school,
        LocalizedKey.Tags.Location.transport,
        LocalizedKey.Tags.Location.outside,
    ]
}
